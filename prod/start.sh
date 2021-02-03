#!/usr/bin/env sh

set -e

ROLE=${CONTAINER_ROLE:-app}
ENVIRONMENT=${APP_ENV:-local}
ARTISAN="/srv/www/artisan"

##############################
##   Function Definitions   ##
##############################

_verify_artisan_is_present() {
  if [ ! -e $ARTISAN ]; then
    echo "Artisan not found."
    exit 1
  fi
}

_print_role_and_environment() {
  echo "Running as $ROLE in $ENVIRONMENT"
}

_register_trap() {
  trap _did_receive_sigterm SIGTERM
}

_enable_development_extensions_if_required() {
  if [ ! -z "${XDEBUG_ENABLED:-}" ] && [ "$XDEBUG_ENABLED" = "1" ] ; then
    sed -i "s/;zend_extension=.*/zend_extension=xdebug.so/g" /etc/php7/conf.d/00_xdebug.ini
  fi
}

_validate_role() {

  for VALID_ROLE in "app" "queue" "scheduler"; do
    if [ $ROLE = "$VALID_ROLE" ]; then
      return 0
    fi
  done

  echo "Invalid role definition" && exit 1
}

_prepare_app_for_production() {
  if [ $ENVIRONMENT = "production" ]; then
      echo "Caching for production.."
      php ${ARTISAN} config:cache
      php ${ARTISAN} view:cache
      php ${ARTISAN} route:cache || echo 'Route caching not possible.'
  fi
}

_run_database_migration() {

  if [ -n "$SKIP_MIGRATIONS" ]; then
    echo "Skipping migrations."
    return
  fi

  if [ -z "$DB_HOST" ]; then
    echo "Skipping migrations as DB_HOST not defined."
    return
  fi

  echo "Running migrations.."
  php ${ARTISAN} migrate --force
}

_did_receive_sigterm() {
  _stop_scheduler
  exit 0
}

_start_fpm() {
  exec php-fpm7 -R --nodaemonize
}

_start_queue_worker() {
  exec php ${ARTISAN} queue:work --sleep=${QUEUE_SLEEP}
}

_wait_on_scheduler_process() {
  wait $SCHEDULER_WAIT_PID
}

_start_scheduler() {
  while true
  do
    php ${ARTISAN} schedule:run --verbose --no-interaction &
    SCHEDULER_PID=$!
    (sleep 60) &
    SCHEDULER_WAIT_PID=$!
    wait "$SCHEDULER_WAIT_PID"
  done
}

_stop_scheduler() {

  echo "SIGTERM received for Scheduler"

  # We'll first send SIGTERM to the PHP process running the scheduler, this
  # will gracefully terminate if we're in the middle of processing a job
  if kill -0 "$SCHEDULER_PID" > /dev/null 2>&1; then
      echo "Waiting for scheduled task to complete.."
      wait "$SCHEDULER_PID"
  fi
  # Once the task has completed, we can terminate the (sleep 60) subshell
  # knowing we don't have any jobs being processed.
  echo "Sending SIGTERM to Scheduler"
  kill "$SCHEDULER_WAIT_PID"
}

####################
##   Entrypoint   ##
####################

_verify_artisan_is_present
_enable_development_extensions_if_required
_print_role_and_environment
_validate_role

# Launch container for specific role.
case $ROLE in
"scheduler")
  _register_trap
  _start_scheduler
  _wait_on_scheduler_process
  ;;
"app")
  _prepare_app_for_production
  _run_database_migration
  _start_fpm
  ;;
"queue")
  _start_queue_worker
  ;;
*)
  echo "Invalid container role" && exit 1
  ;;
esac







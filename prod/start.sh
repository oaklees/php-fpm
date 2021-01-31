#!/usr/bin/env sh

set -e

ROLE=${CONTAINER_ROLE:-app}
ENVIRONMENT=${APP_ENV:-local}
ARTISAN="/srv/www/artisan"

# PHP-FPM configuration
export PM_MAX_CHILDREN=${PM_MAX_CHILDREN:-50}
export PM_START_SERVERS=${PM_START_SERVERS:-10}
export PM_MIN_SPARE_SERVERS=${PM_MIN_SPARE_SERVERS:-5}
export PM_MAX_SPARE_SERVERS=${PM_MAX_SPARE_SERVERS:-10}
export PM_MAX_REQUESTS=${PM_MAX_REQUESTS:-1000}

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

  if [ -n "$FPM_PID" ]; then
    _stop_fpm
  fi

  if [ -n "$DATABASE_WORKER_PID" ]; then
    _stop_database_worker
  fi

  if [ "$ROLE" = "scheduler" ]; then
    _stop_scheduler
  fi

  exit 0
}

_start_fpm() {
  php-fpm7 -R --nodaemonize &
  FPM_PID=$!
}

_stop_fpm () {
  echo "Sending SIGTERM to fpm"
  kill -SIGTERM "$FPM_PID"
  # Wait for the fpm process to exit
  wait "$FPM_PID"
  echo "fpm exited"
}

_start_database_queue_worker() {
  php ${ARTISAN} queue:work &
  DATABASE_WORKER_PID=$!
}

_stop_database_worker () {
  echo "Sending SIGTERM to database worker"
  kill -SIGTERM "$DATABASE_WORKER_PID"
  # Wait for the Database worker process to exit
  wait "$DATABASE_WORKER_PID"
  echo "Database worker exited"
}

_wait_on_active_processes() {
  if [ -n "$FPM_PID" ]; then
    wait $FPM_PID
  fi

  if [ -n "$DATABASE_WORKER_PID" ]; then
    wait $DATABASE_WORKER_PID
  fi
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

  if kill -0 "$SCHEDULER_PID" > /dev/null 2>&1; then
      echo "Waiting for scheduled task to complete.."
      wait "$SCHEDULER_PID"
  fi

  echo "Sending SIGTERM to Scheduler"
  kill "$SCHEDULER_WAIT_PID"
}

####################
##   Entrypoint   ##
####################

_verify_artisan_is_present
_enable_development_extensions_if_required
_print_role_and_environment
_register_trap
_validate_role

if [ "$ROLE" = "scheduler" ]; then
  _start_scheduler
fi

_prepare_app_for_production

if [ "$ROLE" = "app" ]; then
  _run_database_migration
fi

if [ "$ROLE" = "queue" ]; then
  _start_database_queue_worker
fi

_start_fpm
_wait_on_active_processes






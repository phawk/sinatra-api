web: bundle exec iodine -p $PORT -w $WEB_CONCURRENCY -t $MAX_THREADS -www ./public
worker: bundle exec sidekiq -r ./config/boot.rb -C ./config/sidekiq.yml
release: bin/rake db:migrate

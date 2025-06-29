RAILS_ENV ?= development
PORT ?= 3000

.PHONY: setup start test swagger clean db-reset help lint console

setup:
	bundle install
	RAILS_ENV=$(RAILS_ENV) bin/rails db:create db:migrate db:seed

start:
	RAILS_ENV=$(RAILS_ENV) bin/rails server -b 0.0.0.0 -p $(PORT)

test:
	bundle exec rspec

swagger:
	bin/rake rswag:specs:swaggerize

clean:
	rm -rf tmp/cache tmp/pids log/*.log public/assets

db-reset:
	RAILS_ENV=$(RAILS_ENV) bin/rails db:drop db:create db:migrate db:seed

lint:
	bin/rubocop

console:
	RAILS_ENV=$(RAILS_ENV) bin/rails console
help:
	@echo "Makefile commands:"
	@echo "  setup          - Install dependencies and set up the database"
	@echo "  start          - Start the Rails server"
	@echo "  test           - Run test"
	@echo "  swagger        - Generate Swagger documentation"
	@echo "  clean          - Clean temporary files and logs"
	@echo "  db-reset       - Reset the database (drop, create, migrate, seed)"
	@echo "  lint           - Run code linter"
	@echo "  console        - Open Rails console"
	@echo "  help           - Show this help message"
.DEFAULT_GOAL := help

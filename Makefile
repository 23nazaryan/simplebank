DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable

postgres:
	docker run --name postgres-12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres-12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres-12 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc:
	sqlc generate

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/23nazaryan/simplebank/db/sqlc Store

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
		  --go-grpc_out=pb --go-grpc_opt=paths=source_relative --experimental_allow_proto3_optional \
		  --grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
		  --openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simplebank\
		  proto/*.proto
		  statik -src=./doc/swagger -dest=./doc

test:
	go test -v -cover -short ./...

evans:
	evans --host localhost --port 4000 -r repl

redis:
	docker run --name redis -p 6379:6379 -d redis:7.2.4-alpine

.PHONY: network postgres createdb dropdb migrateup migrateup1 migratedown migratedown1 new_migration db_docs db_schema sqlc server mock proto test evans redis
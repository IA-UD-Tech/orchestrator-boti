create extension vector
with
  schema extensions;

CREATE TYPE "permission_types" AS ENUM (
  'Administrator',
  'Manager',
  'User'
);

CREATE TYPE "sender_type" AS ENUM (
  'User',
  'Agent',
  'System'
);

CREATE TYPE "conversation_status" AS ENUM (
  'Active',
  'Finished',
  'Paused',
  'Cancelled'
);

CREATE TABLE "users" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "avatar_url" VARCHAR(500),
  "status" BOOLEAN DEFAULT true,
  "created_at" TIMESTAMP DEFAULT (now()),
  "last_login" TIMESTAMP
);

CREATE TABLE "roles" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE NOT NULL,
  "description" TEXT
);

CREATE TABLE "user_role" (
  "user_id" UUID,
  "role_id" INT,
  "assigned_at" TIMESTAMP DEFAULT (now()),
  PRIMARY KEY ("user_id", "role_id")
);

CREATE TABLE "tools" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(100) UNIQUE NOT NULL,
  "type" VARCHAR(50),
  "description" TEXT,
  "creator_id" UUID,
  "created_at" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "agents" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "name" VARCHAR(100) NOT NULL,
  "description" TEXT,
  "type" VARCHAR(50),
  "tool_id" INT,
  "created_at" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "conversations" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "user_id" UUID,
  "tool_id" INT,
  "start_date" TIMESTAMP DEFAULT (now()),
  "end_date" TIMESTAMP,
  "status" conversation_status,
  "mode" VARCHAR(20) DEFAULT 'Standard',
  "estimated_cost" NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE "messages" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "conversation_id" UUID,
  "sender" sender_type,
  "content" TEXT NOT NULL,
  "sent_at" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "vector_embeddings" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "message_id" UUID,
  "document_id" UUID,
  "agent_id" UUID,
  "vector" vector(1536) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "documents" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "agent_id" UUID,
  "name" VARCHAR(255) NOT NULL,
  "text_content" TEXT NOT NULL,
  "vector" vector(1536) NOT NULL,
  "tool_id" INT,
  "created_at" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "permissions" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "user_id" UUID,
  "tool_id" INT,
  "permission_type" permission_types,
  "interaction_count" INT DEFAULT 0,
  "updated_at" DATE DEFAULT (now())
);

CREATE TABLE "agent_configuration" (
  "id" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "agent_id" UUID,
  "parameter" VARCHAR(100) NOT NULL,
  "value" TEXT NOT NULL,
  "created_at" TIMESTAMP DEFAULT (now())
);

CREATE INDEX "idx_user_email" ON "users" ("email");

CREATE INDEX "idx_conversations_user" ON "conversations" ("user_id");

CREATE INDEX "idx_messages_conversation" ON "messages" ("conversation_id");

CREATE INDEX "idx_vector_embeddings" ON "vector_embeddings" USING IVFFLAT ("vector");

CREATE INDEX "idx_documents_vector" ON "documents" USING IVFFLAT ("vector");

CREATE INDEX "idx_tool_usage_date" ON "permissions" ("updated_at");

ALTER TABLE "agent_configuration" ADD FOREIGN KEY ("agent_id") REFERENCES "agents" ("id") ON DELETE CASCADE;

ALTER TABLE "user_role" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "user_role" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id") ON DELETE CASCADE;

ALTER TABLE "tools" ADD FOREIGN KEY ("creator_id") REFERENCES "users" ("id") ON DELETE SET NULL;

ALTER TABLE "agents" ADD FOREIGN KEY ("tool_id") REFERENCES "tools" ("id") ON DELETE CASCADE;

ALTER TABLE "conversations" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "conversations" ADD FOREIGN KEY ("tool_id") REFERENCES "tools" ("id") ON DELETE CASCADE;

ALTER TABLE "messages" ADD FOREIGN KEY ("conversation_id") REFERENCES "conversations" ("id") ON DELETE CASCADE;

ALTER TABLE "vector_embeddings" ADD FOREIGN KEY ("message_id") REFERENCES "messages" ("id") ON DELETE CASCADE;

ALTER TABLE "documents" ADD FOREIGN KEY ("tool_id") REFERENCES "tools" ("id") ON DELETE CASCADE;

ALTER TABLE "permissions" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;

ALTER TABLE "permissions" ADD FOREIGN KEY ("tool_id") REFERENCES "tools" ("id") ON DELETE CASCADE;

ALTER TABLE "vector_embeddings" ADD FOREIGN KEY ("document_id") REFERENCES "documents" ("id") ON DELETE CASCADE;

ALTER TABLE "vector_embeddings" ADD FOREIGN KEY ("agent_id") REFERENCES "agents" ("id") ON DELETE CASCADE;

ALTER TABLE "documents" ADD FOREIGN KEY ("agent_id") REFERENCES "agents" ("id") ON DELETE CASCADE;

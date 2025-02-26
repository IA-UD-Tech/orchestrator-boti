create extension vector
with
  schema extensions;

CREATE TYPE "tipos_permisos" AS ENUM (
  'Administrador',
  'Manager',
  'Usuario'
);

CREATE TYPE "tipo_remitente" AS ENUM (
  'Usuario',
  'Agente',
  'Sistema'
);

CREATE TYPE "estado_conversacion" AS ENUM (
  'Activa',
  'Finalizada',
  'En_Pausa',
  'Cancelada'
);

CREATE TABLE "usuarios" (
  "id_usuario" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "email" VARCHAR(255) UNIQUE NOT NULL,
  "nombre" VARCHAR(255) NOT NULL,
  "estado" BOOLEAN DEFAULT true,
  "fecha_creacion" TIMESTAMP DEFAULT (now()),
  "ultima_conexion" TIMESTAMP
);

CREATE TABLE "roles" (
  "id_rol" SERIAL PRIMARY KEY,
  "nombre" VARCHAR(50) UNIQUE NOT NULL,
  "descripcion" TEXT
);

CREATE TABLE "usuario_rol" (
  "id_usuario" UUID,
  "id_rol" INT,
  "fecha_asignacion" TIMESTAMP DEFAULT (now()),
  PRIMARY KEY ("id_usuario", "id_rol")
);

CREATE TABLE "herramientas" (
  "id_herramienta" SERIAL PRIMARY KEY,
  "nombre" VARCHAR(100) UNIQUE NOT NULL,
  "tipo" VARCHAR(50),
  "descripcion" TEXT,
  "id_creador" UUID,
  "fecha_creacion" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "agentes" (
  "id_agente" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "nombre" VARCHAR(100) NOT NULL,
  "descripcion" TEXT,
  "tipo" VARCHAR(50),
  "id_herramienta" INT,
  "fecha_creacion" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "conversaciones" (
  "id_conversacion" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "id_usuario" UUID,
  "id_herramienta" INT,
  "fecha_inicio" TIMESTAMP DEFAULT (now()),
  "fecha_fin" TIMESTAMP,
  "estado" estado_conversacion,
  "modo" VARCHAR(20) DEFAULT 'Estándar',
  "costo_estimado" NUMERIC(10,2) DEFAULT 0
);

CREATE TABLE "mensajes" (
  "id_mensaje" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "id_conversacion" UUID,
  "remitente" tipo_remitente,
  "contenido" TEXT NOT NULL,
  "fecha_envio" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "vector_embeddings" (
  "id_embedding" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "id_mensaje" UUID,
  "id_documento" UUID,
  "id_agente" UUID,
  "vector" vector(1536) NOT NULL,
  "fecha_creacion" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "documentos" (
  "id_documento" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "id_agente" UUID,
  "nombre" VARCHAR(255) NOT NULL,
  "contenido_texto" TEXT NOT NULL,
  "vector" vector(1536) NOT NULL,
  "id_herramienta" INT,
  "fecha_creacion" TIMESTAMP DEFAULT (now())
);

CREATE TABLE "permisos" (
  "id_permiso" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "id_usuario" UUID,
  "id_herramienta" INT,
  "tipo_permiso" tipos_permisos,
  "cantidad_interacciones" INT DEFAULT 0,
  "fecha_actualizacion" DATE DEFAULT (now())
);

CREATE TABLE "configuracion_agentes" (
  "id_configuracion" UUID PRIMARY KEY DEFAULT (gen_random_uuid()),
  "id_agente" UUID,
  "parametro" VARCHAR(100) NOT NULL,
  "valor" TEXT NOT NULL,
  "fecha_creacion" TIMESTAMP DEFAULT (now())
);

CREATE INDEX "idx_usuario_email" ON "usuarios" ("email");

CREATE INDEX "idx_conversaciones_usuario" ON "conversaciones" ("id_usuario");

CREATE INDEX "idx_mensajes_conversacion" ON "mensajes" ("id_conversacion");

CREATE INDEX "idx_vector_embeddings" ON "vector_embeddings" USING IVFFLAT ("vector");

CREATE INDEX "idx_documentos_vector" ON "documentos" USING IVFFLAT ("vector");

CREATE INDEX "idx_uso_herramientas_fecha" ON "permisos" ("fecha_actualizacion");

ALTER TABLE "configuracion_agentes" ADD FOREIGN KEY ("id_agente") REFERENCES "agentes" ("id_agente") ON DELETE CASCADE;

ALTER TABLE "usuario_rol" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id_usuario") ON DELETE CASCADE;

ALTER TABLE "usuario_rol" ADD FOREIGN KEY ("id_rol") REFERENCES "roles" ("id_rol") ON DELETE CASCADE;

ALTER TABLE "herramientas" ADD FOREIGN KEY ("id_creador") REFERENCES "usuarios" ("id_usuario") ON DELETE SET NULL;

ALTER TABLE "agentes" ADD FOREIGN KEY ("id_herramienta") REFERENCES "herramientas" ("id_herramienta") ON DELETE CASCADE;

ALTER TABLE "conversaciones" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id_usuario") ON DELETE CASCADE;

ALTER TABLE "conversaciones" ADD FOREIGN KEY ("id_herramienta") REFERENCES "herramientas" ("id_herramienta") ON DELETE CASCADE;

ALTER TABLE "mensajes" ADD FOREIGN KEY ("id_conversacion") REFERENCES "conversaciones" ("id_conversacion") ON DELETE CASCADE;

ALTER TABLE "vector_embeddings" ADD FOREIGN KEY ("id_mensaje") REFERENCES "mensajes" ("id_mensaje") ON DELETE CASCADE;

ALTER TABLE "documentos" ADD FOREIGN KEY ("id_herramienta") REFERENCES "herramientas" ("id_herramienta") ON DELETE CASCADE;

ALTER TABLE "permisos" ADD FOREIGN KEY ("id_usuario") REFERENCES "usuarios" ("id_usuario") ON DELETE CASCADE;

ALTER TABLE "permisos" ADD FOREIGN KEY ("id_herramienta") REFERENCES "herramientas" ("id_herramienta") ON DELETE CASCADE;

ALTER TABLE "vector_embeddings" ADD FOREIGN KEY ("id_documento") REFERENCES "documentos" ("id_documento") ON DELETE CASCADE;

ALTER TABLE "vector_embeddings" ADD FOREIGN KEY ("id_agente") REFERENCES "agentes" ("id_agente") ON DELETE CASCADE;

ALTER TABLE "documentos" ADD FOREIGN KEY ("id_agente") REFERENCES "agentes" ("id_agente") ON DELETE CASCADE;

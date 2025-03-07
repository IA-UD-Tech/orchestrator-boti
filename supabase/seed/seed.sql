-- Insert default roles into the roles table
INSERT INTO roles (name, description) 
VALUES 
  ('Docente', 'Profesor con acceso a herramientas de enseñanza y evaluación'),
  ('Estudiante', 'Usuario con acceso a recursos de aprendizaje'),
  ('Admin', 'Usuario con privilegios administrativos completos');
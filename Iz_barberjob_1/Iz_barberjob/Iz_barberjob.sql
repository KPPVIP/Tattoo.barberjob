USE `essentialmode`;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  ('barber',0,'employe','Employé',250, '{}', '{}'),
  ('barber',1,'boss','Patron',250, '{}', '{}')
;

INSERT INTO `jobs` (name, label) VALUES
  ('barber','Barbershop')
;

INSERT INTO `addon_account` (name, label, shared) VALUES
  ('barber', 'Barbershop', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('barber', 'Barbershop', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('barber', 'Barbershop', 1)
;
CREATE TABLE Utilisateurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Membre') DEFAULT 'Membre'
);

CREATE TABLE Projets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    description TEXT,
    date_debut DATE NOT NULL,
    date_fin DATE
);

CREATE TABLE Tâches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    description TEXT,
    date_limite DATE,
    status ENUM('À faire', 'En cours', 'Terminé') DEFAULT 'À faire',
    projet_id INT NOT NULL,
    FOREIGN KEY (projet_id) REFERENCES Projets(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Collaborateurs (
    utilisateur_id INT NOT NULL,
    projet_id INT NOT NULL,
    rôle_projet ENUM('Propriétaire', 'Contributeur') DEFAULT 'Contributeur',
    PRIMARY KEY (utilisateur_id, projet_id),
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (projet_id) REFERENCES Projets(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE Commentaires (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contenu TEXT NOT NULL,
    date_post DATETIME DEFAULT CURRENT_TIMESTAMP,
    utilisateur_id INT NOT NULL,
    tâche_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES Utilisateurs(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (tâche_id) REFERENCES Tâches(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

INSERT INTO Utilisateurs (email, password_hash, role) VALUES
('admin@example.com', 'hashed_password1', 'Admin'),
('user1@example.com', 'hashed_password2', 'Membre');

INSERT INTO Projets (nom, description, date_debut, date_fin)
VALUES
('Projet A', 'Développement d’une application mobile', '2024-01-01', '2024-06-30'),
('Projet B', 'Création d’un site web e-commerce', '2024-02-15', '2024-09-15'),
('Projet C', 'Refonte d’un système d’information', '2024-03-01', NULL);

INSERT INTO Tâches (titre, description, date_limite, status, projet_id)
VALUES
('Analyse des besoins', 'Recueillir les besoins des utilisateurs', '2024-01-15', 'À faire', 1),
('Design UI', 'Créer des maquettes pour l’application', '2024-02-01', 'En cours', 1),
('Développement backend', 'Implémenter les API pour le projet', '2024-03-15', 'À faire', 1),
('Ajout de fonctionnalités', 'Développer des modules spécifiques', '2024-05-01', 'À faire', 2),
('Tests finaux', 'Effectuer des tests de validation', '2024-06-01', 'Terminé', 2);


INSERT INTO Commentaires (contenu, utilisateur_id, tâche_id)
VALUES
('C’est une excellente idée pour le design.', 2, 2),
('Les API doivent être prêtes pour le mois prochain.', 1, 3),
('Merci pour cette clarification !', 1, 5),
('Peut-on ajouter un diagramme au rapport ?', 2, 1);


INSERT INTO Collaborateurs (utilisateur_id, projet_id, rôle_projet)
VALUES
(1, 1, 'Propriétaire'),
(2, 1, 'Contributeur'),
(1, 2, 'Propriétaire'),
(2, 3, 'Contributeur');

SELECT p.nom AS projet, t.titre AS tâche, t.status
FROM Projets p
JOIN Tâches t ON p.id = t.projet_id;

SELECT u.email, c.rôle_projet
FROM Collaborateurs c
JOIN Utilisateurs u ON c.utilisateur_id = u.id
WHERE c.projet_id = 1;

SELECT com.contenu, u.email, com.date_post
FROM Commentaires com
JOIN Utilisateurs u ON com.utilisateur_id = u.id
WHERE com.tâche_id = 2;

SELECT t.id, t.titre, t.status
FROM Tâches t
WHERE t.projet_id = 1;

SELECT t.status, COUNT(*) AS nombre_tâches
FROM Tâches t
WHERE t.projet_id = 1
GROUP BY t.status;

SELECT u.email, c.rôle_projet
FROM Collaborateurs c
JOIN Utilisateurs u ON c.utilisateur_id = u.id
WHERE c.projet_id = 1;

SELECT com.contenu, com.date_post, u.email
FROM Commentaires com
JOIN Utilisateurs u ON com.utilisateur_id = u.id
WHERE com.tâche_id = 2;




# Étape 1 : Construire l'application
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app

# Copier le fichier pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline

# Copier tout le projet et le construire
COPY . .
RUN mvn clean package -DskipTests

# Étape 2 : Créer l'image finale
FROM openjdk:17-jdk-slim
WORKDIR /app

# Copier l'artefact JAR du build précédent
COPY --from=build /app/target/*.jar app.jar

# Exposer le port de l'application
EXPOSE 8081

# Démarrer l'application Spring Boot
ENTRYPOINT ["java", "-jar", "app.jar"]

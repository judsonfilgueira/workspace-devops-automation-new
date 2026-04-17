FROM maven:3.9-eclipse-temurin-17-alpine AS builder

WORKDIR /app

# Copia o pom primeiro (cache de dependência)
COPY pom.xml .

RUN mvn -B -q -DskipTests dependency:go-offline

# Copia o código
COPY src ./src

# Build
RUN mvn clean package -DskipTests

# --------- RUNTIME ---------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]

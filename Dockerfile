####
# Build image
####

FROM openjdk:11-jre

RUN apt update && apt install -y git

RUN mkdir /build /minecraft
WORKDIR /build
RUN wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O /build/BuildTools.jar
RUN java -jar BuildTools.jar
RUN cp spigot*.jar /minecraft/spigot.jar && \
	cp Spigot/Spigot-API/target/spigot-api*SNAPSHOT.jar /minecraft/spigot-api.jar



####
# Actual image
####

FROM openjdk:11-jre

RUN apt update && apt dist-upgrade -y

COPY --from=0 /minecraft /minecraft

WORKDIR /minecraft
COPY ./include/* ./

ENTRYPOINT ["/bin/bash", "/minecraft/start.sh"]

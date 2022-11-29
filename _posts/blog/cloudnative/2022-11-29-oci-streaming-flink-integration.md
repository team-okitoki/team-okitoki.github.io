---
layout: page-fullwidth
#
# Content
#
subheadline: "CloudNative"
title: "Streaming Cloud Service with Kafka and Flink"
teaser: "OCI Streaming 서비스는 Apache Kafka API와 호환성을 제공하고 있습니다. 이번 글에서는 OCI Streaming Service와 함께 데이터 생산자(Producer)로 Kafka, 소비자(Consumer)로 Flink를 사용하는 방법을 정리하였습니다."
author: dankim
breadcrumb: true
categories:
  - cloudnative
tags:
  - [oci, streaming, kafka, flink]
#
# Styling
#
header: no
#  image:
#    title: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
#     thumb: /assets/img/cloudnative-security/2022/weblogic_oke_0.png
#     homepage: mediaplayer_js-home.jpg
#     caption: Photo by Corey Blaz
#     caption_url: https://blaz.photography/
# mediaplayer: true

---

<div class="panel radius" markdown="1">
**Table of Contents**
{: #toc }
*  TOC
{:toc}
</div>

### Stream(Topic) 구성
우선 OCI에서 Stream을 사용할 수 있도록 구성하고 Kafka 관련 접속 정보를 얻어야 합니다.

#### Stream(Topic) 생성
OCI Streaming Service에서 Stream(Topic)을 생성하는 절차는 간단합니다. OCI 콘솔에 접속한 후 **메뉴 >Analytics & AI > 스트리밍(Streaming) > 스트림 생성** 경로로 이동해서 생성할 수 있습니다.

![](https://mangdan.github.io/assets/images/oci-create-streaming.png)

#### Stream Pool (Stream Group) 및 Kafka 접속 정보
Stream Pool은 Stream의 Group을 의미합니다. 위에서 생성한 Stream에 별도의 Stream Pool을 지정하지 않은 경우 기본 Stream Pool (DefaultPool)에 포함됩니다. Stream Pool을 보면 Stream Pool에 접속을 위한 Kafka 설정을 포함하고 있습니다. 이 정보를 이용해서 Kafka 및 Flink 설정을 하게 됩니다.
* 부트 스트랩 서버: cell-1.streaming.{Region-Code}.oci.oraclecloud.com:9092
* SASL 접속 문자열: org.apache.kafka.common.security.plain.PlainLoginModule required username=”{테넌시명}/{OCI 계정}/{Stream Pool OCID}” * password=”{AUTH_TOKEN}”;
* 보안 프로토콜: SASL_SSL
* 보안 방식: PLAIN

#### Auth Token 생성
Kafka 접속 정보에서 필요한 정보를 얻을 수 있지만, 자신의 계정과 연관된 AUTH_TOKEN은 생성해 줘야합니다. 다음 순서로 토큰을 생성합니다.
* 우측 상단 프로파일 클릭 > 계정 선택 > 인증 토큰 > 토큰 생성 > 복사

![](https://mangdan.github.io/assets/images/oci-oss-create-token.png)

### Flink 환경 구성
Flink 환경을 구성하고 소비자(Consumer)를 작성하여 실행할 것입니다. 여기서는 로컬 클러스터 환경으로 구성하도록 하겠습니다.

#### Flink 설치
설치는 아래 링크를 참고합니다.  
[https://ci.apache.org/projects/flink/flink-docs-release-1.9/getting-started/tutorials/local_setup.html](https://ci.apache.org/projects/flink/flink-docs-release-1.9/getting-started/tutorials/local_setup.html)

MacOS의 경우 다음과 같이 HomeBrew를 활용하면 쉽게 설치할 수 있습니다.
```terminal
$ brew install apache-flink

$ flink --version
```

#### Flink 클러스터 실행
MacOS에서 HomeBrew로 설치한 경우 보통 /usr/local/Cellar/apache-flink/{버전}과 같은 위치에 설치됩니다. 정확한 경로 위치는 다음과 같이 brew info로 확인할 수 있습니다.

```terminal
$ brew info apache-flink

apache-flink: stable 1.16.0, HEAD
Scalable batch and stream data processing
https://flink.apache.org/
/usr/local/Cellar/apache-flink/1.16.0 (174 files, 336MB) *
  Built from source on 2022-11-04 at 14:46:29
From: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/apache-flink.rb
License: Apache-2.0
==> Requirements
Required: java = 1.8 ✔
==> Options
--HEAD
	Install HEAD version
==> Analytics
install: 713 (30 days), 2,253 (90 days), 13,079 (365 days)
install-on-request: 714 (30 days), 2,243 (90 days), 13,028 (365 days)
build-error: 0 (30 days)
```

다음과 같이 이동하여 실행합니다.

```
$ cd /usr/local/Cellar/apache-flink/1.16.0/libexec/bin

$ ./start-cluster.sh
```

이제 Flink에서 제공하는 관리 콘솔에 접속해 봅니다.
* http://localhost:8081

![](https://mangdan.github.io/assets/images/oci-oss-flink-dashboard.png)

### Flink 소비자(Consumer)
Flink는 Java와 Scala를 통해 코드를 작성할 수 있습니다. 여기서는 메이븐 프로젝트와 Java를 활용하여 작성하였습니다.

#### Flink 소비자 코드 작성
Flink는 최신 버전인 1.16.0 버전을 사용하였습니다. 아래와 같이 Dependency와 Maven Plugin 설정을 합니다.

**pom.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.example.app</groupId>
	<artifactId>oss-kafka-flink-consumer</artifactId>
	<packaging>jar</packaging>
	<version>1.0-SNAPSHOT</version>
	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
		<flink.version>1.16.0</flink.version>
	</properties>
	<dependencies>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-connector-kafka</artifactId>
			<version>${flink.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-java</artifactId>
			<version>${flink.version}</version>
		</dependency>
		<dependency>
			<groupId>org.apache.flink</groupId>
			<artifactId>flink-streaming-java</artifactId>
			<version>${flink.version}</version>
		</dependency>
	</dependencies>
	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-resources-plugin</artifactId>
				<version>3.2.0</version>
			</plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-shade-plugin</artifactId>
				<version>3.2.4</version>
				<executions>
					<!-- Run shade goal on package phase -->
					<execution>
						<phase>package</phase>
						<goals>
							<goal>shade</goal>
						</goals>
						<configuration>
							<artifactSet>
								<excludes>
									<!-- This list contains all dependencies of flink-dist
									Everything else will be packaged into the fat-jar
									-->
									<exclude>org.apache.flink:flink-shaded-*</exclude>
									<exclude>org.apache.flink:flink-core</exclude>
									<exclude>org.apache.flink:flink-java</exclude>
									<exclude>org.apache.flink:flink-scala</exclude>
									<exclude>org.apache.flink:flink-runtime</exclude>
									<exclude>org.apache.flink:flink-optimizer</exclude>
									<exclude>org.apache.flink:flink-clients</exclude>
									<exclude>org.apache.flink:flink-avro</exclude>
									<exclude>org.apache.flink:flink-java-examples</exclude>
									<exclude>org.apache.flink:flink-scala-examples</exclude>
									<exclude>org.apache.flink:flink-streaming-examples</exclude>
									<exclude>org.apache.flink:flink-streaming-java</exclude>

									<!-- Also exclude very big transitive dependencies of Flink
									WARNING: You have to remove these excludes if your code relies on other
									versions of these dependencies.
									-->
									<exclude>org.scala-lang:scala-library</exclude>
									<exclude>org.scala-lang:scala-compiler</exclude>
									<exclude>org.scala-lang:scala-reflect</exclude>
									<exclude>com.amazonaws:aws-java-sdk</exclude>
									<exclude>com.typesafe.akka:akka-actor_*</exclude>
									<exclude>com.typesafe.akka:akka-remote_*</exclude>
									<exclude>com.typesafe.akka:akka-slf4j_*</exclude>
									<exclude>io.netty:netty-all</exclude>
									<exclude>io.netty:netty</exclude>
									<exclude>org.eclipse.jetty:jetty-server</exclude>
									<exclude>org.eclipse.jetty:jetty-continuation</exclude>
									<exclude>org.eclipse.jetty:jetty-http</exclude>
									<exclude>org.eclipse.jetty:jetty-io</exclude>
									<exclude>org.eclipse.jetty:jetty-util</exclude>
									<exclude>org.eclipse.jetty:jetty-security</exclude>
									<exclude>org.eclipse.jetty:jetty-servlet</exclude>
									<exclude>commons-fileupload:commons-fileupload</exclude>
									<exclude>org.apache.avro:avro</exclude>
									<exclude>commons-collections:commons-collections</exclude>
									<exclude>org.codehaus.jackson:jackson-core-asl</exclude>
									<exclude>org.codehaus.jackson:jackson-mapper-asl</exclude>
									<exclude>com.thoughtworks.paranamer:paranamer</exclude>
									<exclude>org.xerial.snappy:snappy-java</exclude>
									<exclude>org.apache.commons:commons-compress</exclude>
									<exclude>org.tukaani:xz</exclude>
									<exclude>com.esotericsoftware.kryo:kryo</exclude>
									<exclude>com.esotericsoftware.minlog:minlog</exclude>
									<exclude>org.objenesis:objenesis</exclude>
									<exclude>com.twitter:chill_*</exclude>
									<exclude>com.twitter:chill-java</exclude>
									<exclude>com.twitter:chill-avro_*</exclude>
									<exclude>com.twitter:chill-bijection_*</exclude>
									<exclude>com.twitter:bijection-core_*</exclude>
									<exclude>com.twitter:bijection-avro_*</exclude>
									<exclude>commons-lang:commons-lang</exclude>
									<exclude>junit:junit</exclude>
									<exclude>de.javakaffee:kryo-serializers</exclude>
									<exclude>joda-time:joda-time</exclude>
									<exclude>org.apache.commons:commons-lang3</exclude>
									<exclude>org.slf4j:slf4j-api</exclude>
									<exclude>org.slf4j:slf4j-log4j12</exclude>
									<exclude>log4j:log4j</exclude>
									<exclude>org.apache.commons:commons-math</exclude>
									<exclude>org.apache.sling:org.apache.sling.commons.json</exclude>
									<exclude>commons-logging:commons-logging</exclude>
									<exclude>org.apache.httpcomponents:httpclient</exclude>
									<exclude>org.apache.httpcomponents:httpcore</exclude>
									<exclude>commons-codec:commons-codec</exclude>
									<exclude>com.fasterxml.jackson.core:jackson-core</exclude>
									<exclude>com.fasterxml.jackson.core:jackson-databind</exclude>
									<exclude>com.fasterxml.jackson.core:jackson-annotations</exclude>
									<exclude>org.codehaus.jettison:jettison</exclude>
									<exclude>stax:stax-api</exclude>
									<exclude>com.typesafe:config</exclude>
									<exclude>org.uncommons.maths:uncommons-maths</exclude>
									<exclude>com.github.scopt:scopt_*</exclude>
									<exclude>org.mortbay.jetty:servlet-api</exclude>
									<exclude>commons-io:commons-io</exclude>
									<exclude>commons-cli:commons-cli</exclude>
								</excludes>
							</artifactSet>
							<filters>
								<filter>
									<artifact>org.apache.flink:*</artifact>
									<excludes>
										<exclude>org/apache/flink/shaded/**</exclude>
										<exclude>web-docs/**</exclude>
									</excludes>
								</filter>
								<filter>
									<!-- Do not copy the signatures in the META-INF folder.
									Otherwise, this might cause SecurityExceptions when using the JAR. -->
									<artifact>*:*</artifact>
									<excludes>
										<exclude>META-INF/*.SF</exclude>
										<exclude>META-INF/*.DSA</exclude>
										<exclude>META-INF/*.RSA</exclude>
									</excludes>
								</filter>
							</filters>
							<transformers>
								<!-- add Main-Class to manifest file -->
								<transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
									<mainClass>com.example.app.FlinkTestConsumer</mainClass>
								</transformer>
							</transformers>
							<createDependencyReducedPom>false</createDependencyReducedPom>
						</configuration>
					</execution>
				</executions>
			</plugin>

			<!-- Configure the jar plugin to add the main class as a manifest entry -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-jar-plugin</artifactId>
				<version>2.5</version>
				<configuration>
					<archive>
						<manifestEntries>
							<Main-Class>com.example.app.FlinkTestConsumer</Main-Class>
						</manifestEntries>
					</archive>
				</configuration>
			</plugin>

			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.8.1</version>
				<configuration>
					<release>8</release>
				</configuration>
			</plugin>
		</plugins>
	</build>
	<profiles>
		<profile>
			<!-- A profile that does everyting correctly:
			We set the Flink dependencies to provided -->
			<id>build-jar</id>
			<activation>
				<activeByDefault>false</activeByDefault>
			</activation>
			<dependencies>
				<dependency>
					<groupId>org.apache.flink</groupId>
					<artifactId>flink-java</artifactId>
					<version>${flink.version}</version>
					<scope>provided</scope>
				</dependency>
				<dependency>
					<groupId>org.apache.flink</groupId>
					<artifactId>flink-streaming-java</artifactId>
					<version>${flink.version}</version>
					<scope>provided</scope>
				</dependency>
				<dependency>
					<groupId>org.apache.flink</groupId>
					<artifactId>flink-clients</artifactId>
					<version>${flink.version}</version>
					<scope>provided</scope>
				</dependency>
			</dependencies>
		</profile>
	</profiles>
</project>
```

다음은 OCI Streaming Service 접속을 위한 설정 파일을 작성합니다. 여기서 Stream Pool에서 확인한 Kafka 접속 정보를 사용합니다.

**consumer.config**  
```
bootstrap.servers=cell-1.streaming.ap-seoul-1.oci.oraclecloud.com:9092
group.id=FlinkExampleConsumer
request.timeout.ms=60000
sasl.mechanism=PLAIN
security.protocol=SASL_SSL
sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username=\"{테넌시명}/{사용자 계정}/{Stream Pool OCID}\" password=\"{AUTH_TOKEN}\";
```

Java로 작성된 코드이며, FlinkKafkaConsumer로 Stream(Topic)으로 메시지를 수신하여 출력만 하는 역할을 하는 간단한 코드입니다.
```java
@SuppressWarnings("all")
public class FlinkTestConsumer {

    private static final String TOPIC = "flink-topic";
    private static final String FILE_PATH = "src/main/resources/consumer.config";

    public static void main(String... args) {
        try {
            //Load properties from config file
            Properties properties = new Properties();
            properties.load(new FileReader(FILE_PATH));
            
            final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
            DataStream<String> stream = env.addSource(new FlinkKafkaConsumer011<String>(TOPIC, new SimpleStringSchema(), properties));
            stream.print();
            env.execute("Testing flink consumer");

        } catch(FileNotFoundException e){
            System.out.println("FileNoteFoundException: " + e);
        } catch (Exception e){
            System.out.println("Failed with exception " + e);
        }
    }
}
```

#### 빌드 및 잡(Job) 실행
**빌드**
```terminal
$ mvn package
```

**잡 실행**
```terminal
$ flink run -c "com.example.app.FlinkTestConsumer" target/oss-kafka-flink-consumer-1.0-SNAPSHOT.jar 

Job has been submitted with JobID fe7e3abba870a537cf4f5a7961ae924e
```

**잡(Job) 실행 확인**
![](https://mangdan.github.io/assets/images/oci-oss-flink-running-jobs.png)

### Kafka 생산자 (Producer)
Kafka 생산자는 Java로 작성하였습니다.

#### Kafka 생산자 코드 작성
Kafka Dependency 설정과 함께 Jar 실행 시 Kafka 관련 Library추가를 위한 Maven Plugin 구성을 합니다.

**pom.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.example.app</groupId>
	<artifactId>oss-kafka-producer</artifactId>
	<packaging>jar</packaging>
	<version>1.0-SNAPSHOT</version>
	<properties>
		<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		<project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
		<kafka.version>3.3.1</kafka.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>org.apache.kafka</groupId>
			<artifactId>kafka-clients</artifactId>
			<version>${kafka.version}</version>
		</dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-api</artifactId>
			<version>2.0.5</version>
		</dependency>
		<dependency>
			<groupId>ch.qos.logback</groupId>
			<artifactId>logback-classic</artifactId>
			<version>1.4.5</version>
		  </dependency>
		<dependency>
			<groupId>org.slf4j</groupId>
			<artifactId>slf4j-log4j12</artifactId>
			<version>2.0.5</version>
		</dependency>
		<dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.14.1</version>
        </dependency> 
	</dependencies>
	<build>
		<defaultGoal>install</defaultGoal>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<version>3.8.1</version>
				<configuration>
					<release>8</release>
				</configuration>
			</plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-resources-plugin</artifactId>
				<version>3.2.0</version>
				<configuration>
					<encoding>UTF-8</encoding>
				</configuration>
			</plugin>
			<plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-dependency-plugin</artifactId>
                <version>3.1.2</version>
                <executions>
                    <execution>
                        <id>copy-dependencies</id>
                        <phase>package</phase>
                        <goals>
                            <goal>copy-dependencies</goal>
                        </goals>
                        <configuration>
                            <outputDirectory>${project.build.directory}/libs</outputDirectory>
                            <overWriteReleases>false</overWriteReleases>
                            <overWriteSnapshots>false</overWriteSnapshots>
                            <overWriteIfNewer>true</overWriteIfNewer>
                            <includeScope>runtime</includeScope>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-jar-plugin</artifactId>
				<version>2.5</version>
				<configuration>
					<archive>
						<manifest>
							<addClasspath>true</addClasspath>
							<addExtensions>true</addExtensions> 
							<mainClass>com.example.app.KafkaProducerExample</mainClass>
							<classpathPrefix>libs/</classpathPrefix>                            
						</manifest>
						<!-- <manifestEntries>
							<Class-Path>libs/kafka-clients-2.6.0.jar</Class-Path>
						</manifestEntries> -->
					</archive>
				</configuration>
			</plugin>
		</plugins>
	</build>
	<profiles>
		<profile>
			<!-- A profile that does everyting correctly:
			We set the Flink dependencies to provided -->
			<id>build-jar</id>
			<activation>
				<activeByDefault>false</activeByDefault>
			</activation>
			<dependencies>
				<dependency>
					<groupId>org.apache.kafka</groupId>
					<artifactId>kafka-clients</artifactId>
					<version>${kafka.version}</version>
					<scope>provided</scope>
				</dependency>
			</dependencies>
		</profile>
	</profiles>
</project>
```

실행 시 5건의 텍스트 메시지를 OCI Streaming Service로 전송하도록 다음과 같이 코드를 작성하였습니다.
```java
@SuppressWarnings("all")
public class CompatibleProducer {

    public void produce() {
        String authToken = "{AUTH_TOKEN}";
        String tenancyName = "{테넌시명}";
        String username = "{사용자 계정}";
        String streamPoolId = "{Stream Pool OCID}";
        String topicName = "{Stream Name/Topic Name}";

        Properties properties = new Properties();
        properties.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "cell-1.streaming.ap-seoul-1.oci.oraclecloud.com:9092");
        properties.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        properties.put(ProducerConfig.TRANSACTION_TIMEOUT_CONFIG, 5000);
        properties.put(ProducerConfig.DELIVERY_TIMEOUT_MS_CONFIG, 5000);
        properties.put(ProducerConfig.REQUEST_TIMEOUT_MS_CONFIG, 5000);
        properties.put("sasl.mechanism", "PLAIN");
        properties.put("security.protocol", "SASL_SSL");
        properties.put("sasl.jaas.config",
                        "org.apache.kafka.common.security.plain.PlainLoginModule required username=\""
                        + tenancyName + "/"
                        + username + "/"
                        + streamPoolId + "\" "
                        + "password=\""
                        + authToken + "\";"
        );
        properties.put("retries", 5); // retries on transient errors and load balancing disconnection
        properties.put("max.request.size", 1024 * 1024); // limit request size to 1MB

        KafkaProducer producer = new KafkaProducer(properties);
        
        for (int i = 0; i < 5; i++) {
            ProducerRecord record = new ProducerRecord(topicName, UUID.randomUUID().toString(), "Test record #" + i);
            
            producer.send(record, (md, ex) -> {
                if( ex != null ) {
                    ex.printStackTrace();
                }
                else {
                    System.out.println(
                            "Sent msg to "
                                    + md.partition()
                                    + " with offset "
                                    + md.offset()
                                    + " at "
                                    + md.timestamp()
                    );
                }
            });
        }
        producer.flush();
        producer.close();
        System.out.println("produced 5 messages");
    }

}
```
#### 빌드 및 생산자 실행
**빌드**
```
$ mvn package
```

**실행**
```
$ java -jar target/oss-kafka-producer-1.0-SNAPSHOT.jar

00:11 INFO  o.a.k.c.s.a.AbstractLogin - Successfully logged in.
00:11 INFO  o.a.kafka.common.utils.AppInfoParser - Kafka version: 2.6.0
00:11 INFO  o.a.kafka.common.utils.AppInfoParser - Kafka commitId: 62abe01bee039651
00:11 INFO  o.a.kafka.common.utils.AppInfoParser - Kafka startTimeMs: 1601824282658
00:11 INFO  org.apache.kafka.clients.Metadata - [Producer clientId=producer-1] Cluster ID: OSS
Sent msg to 0 with offset 15 at 1601824286584
Sent msg to 0 with offset 16 at 1601824286584
Sent msg to 0 with offset 17 at 1601824286584
Sent msg to 0 with offset 18 at 1601824286584
Sent msg to 0 with offset 19 at 1601824286584
00:11 INFO  o.a.k.clients.producer.KafkaProducer - [Producer clientId=producer-1] Closing the Kafka producer with timeoutMillis = 9223372036854775807 ms.
produced 5 messages
```

**게시된 메시지를 OCI Streaming Service에서 확인**
![](https://mangdan.github.io/assets/images/oci-oss-recent-messages.png)

### Flink Job Task 확인
Flink Console에서 Task Managers > Stdout으로 이동하여 소비한 메시지를 확인할 수 있습니다.
![](https://mangdan.github.io/assets/images/oci-oss-flink-stdout.png)

### 소스 공유
소스는 다음 [깃헙 저장소](https://github.com/MangDan/oci-streaming-examples)에서 확인할 수 있습니다.

### 참고
* [https://blogs.oracle.com/developers/oracle-streaming-service-producer-consumer](https://blogs.oracle.com/developers/oracle-streaming-service-producer-consumer)
* [https://github.com/igfasouza/OSS_examples](https://github.com/igfasouza/OSS_examples)


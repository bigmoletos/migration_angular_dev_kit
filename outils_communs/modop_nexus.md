# Nexus environment configuration

## Table des matières

1. [Nexus Server](#nexus-server)
2. [Setup environment](#setup-environment)
3. [Upgrade gradle configuration](#upgrade-gradle-configuration)
4. [Troubleshooting](#troubleshooting)
   - [Certificate errors](#certificate-errors)

## Nexus Server

Nexus V4 server hosted on the OVH public cloud is accessible from https://nexus.pwcv4.com with the following credentials:

- User: `hps-user`
- Password: `SjuVFa2NAaxr7UQPD3vH8Pn2`

## Setup environment

### For Linux

Add following commands to `.profile` or `.bashrc` files:

```shell
export NEXUS_URL=https://nexus.pwcv4.com
export NEXUS_MVN_PUBLIC_URL=${NEXUS_URL}/repository/maven-public/
export NEXUS_MVN_RELEASES_URL=${NEXUS_URL}/repository/maven-releases/
export NEXUS_MVN_SNAPSHOTS_URL=${NEXUS_URL}/repository/maven-snapshots/
export NEXUS_USER=hps-user
export NEXUS_PASSWORD=SjuVFa2NAaxr7UQPD3vH8Pn2
export dockerRegistry=183w0151.gra7.container-registry.ovh.net/pwcv4
export dockerFromImage=${dockerRegistry}/toolbox/pwc-java-base-image:java17
export dockerLogin=hps-user
export dockerPassword=uWz7^x0^D5VoLUw9
```

### For Windows

Set following environment variables:

```powershell
$env:NEXUS_URL="https://nexus.pwcv4.com"
$env:NEXUS_MVN_PUBLIC_URL="$env:NEXUS_URL/repository/maven-public/"
$env:NEXUS_MVN_RELEASES_URL="$env:NEXUS_URL/repository/maven-releases/"
$env:NEXUS_MVN_SNAPSHOTS_URL="$env:NEXUS_URL/repository/maven-snapshots/"
$env:NEXUS_USER="hps-user"
$env:NEXUS_PASSWORD="SjuVFa2NAaxr7UQPD3vH8Pn2"
$env:dockerRegistry="183w0151.gra7.container-registry.ovh.net/pwcv4"
$env:dockerFromImage="$env:dockerRegistry/toolbox/pwc-java-base-image:java17"
$env:dockerLogin="hps-user"
$env:dockerPassword="uWz7^x0^D5VoLUw9"
```

## Upgrade gradle configuration

Update your `build.gradle` or `settings.gradle` to use Nexus repositories:

```gradle
repositories {
    maven {
        url = uri("${System.getenv('NEXUS_MVN_PUBLIC_URL')}")
        credentials {
            username = System.getenv('NEXUS_USER')
            password = System.getenv('NEXUS_PASSWORD')
        }
    }
}
```

For publishing artifacts:

```gradle
publishing {
    repositories {
        maven {
            def releasesRepoUrl = uri("${System.getenv('NEXUS_MVN_RELEASES_URL')}")
            def snapshotsRepoUrl = uri("${System.getenv('NEXUS_MVN_SNAPSHOTS_URL')}")
            url = version.endsWith('SNAPSHOT') ? snapshotsRepoUrl : releasesRepoUrl
            credentials {
                username = System.getenv('NEXUS_USER')
                password = System.getenv('NEXUS_PASSWORD')
            }
        }
    }
}
```

## Troubleshooting

### Certificate errors

If you encounter SSL certificate errors when connecting to Nexus:

1. **Download the certificate**:
   ```bash
   openssl s_client -showcerts -connect nexus.pwcv4.com:443 </dev/null 2>/dev/null | openssl x509 -outform PEM > nexus.crt
   ```

2. **Import into Java keystore**:
   ```bash
   keytool -import -alias nexus -keystore $JAVA_HOME/lib/security/cacerts -file nexus.crt
   ```
   Default keystore password is usually `changeit`

3. **For Gradle, you can also disable SSL verification** (not recommended for production):
   ```gradle
   repositories {
       maven {
           url = uri("${System.getenv('NEXUS_MVN_PUBLIC_URL')}")
           allowInsecureProtocol = true
           credentials {
               username = System.getenv('NEXUS_USER')
               password = System.getenv('NEXUS_PASSWORD')
           }
       }
   }
   ```

---

**Note**: Keep credentials secure and never commit them to version control. Use environment variables or secure credential management systems.

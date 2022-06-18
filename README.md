# Speed-up patch for Apache Tika Server 1.18

## Note: this is just an example of patching a Java program. The performance issue at hand has been resolved by Apache Tika developers.

Through jvisualvm it's obvious that the language detector is very time consuming. This patch removes language detection which will enhance the overall speed by many factors. It probably works on older versions as well.

## AUTHOR

Phazor / Cascade 1733

## LICENSE

Please feel free to copy the shell-script (tika-patch.sh), distribute and change it in any way you like. The java-classes are under the Apache License, Version 2.0

## INSTRUCTIONS

1. Download tika-server-1.18.jar from Apache Tika official website.
2. Clone this repository
3. Run ./tika-patch.sh tika-server-1.18.jar

## COMPILE

To compile and update the jar-file:

- javac -cp tika-server-1.18.jar org/apache/tika/server/resource/*.java
- zip -u tika-server-1.18.jar org/apache/tika/server/resource/*.class

## RUN

- java -jar tika-server-1.18.jar
- curl -X PUT -T SomeFile localhost:9998/rmeta

## DETAILS

The patch effects the following classes: MetadataResource.java, RecursiveMedataResource.java

### MetadataResource.java

_Changing this:_

```java
    TikaResource.parse(parser, LOG, info.getPath(), is,
                new LanguageHandler() {
                    public void endDocument() {
                        metadata.set("language", getLanguage().getLanguage());
                    }}, metadata, context);
```

_To this:_

```java
    import org.xml.sax.helpers.DefaultHandler;

    TikaResource.parse(parser, LOG, info.getPath(), is, new DefaultHandler(), metadata, context);
```

_Comments: Apache Tika Server returns NullPointerException if the ContentHandler pointer is null. Probably a bug. This is not an issue with RecursiveMetadataResource.java_

### RecursiveMetadataResource.java

_Changing this:_

```java
    TikaResource.parse(wrapper, LOG, info.getPath(), is,
                new LanguageHandler() {
                    public void endDocument() {
                        metadata.set("language", getLanguage().getLanguage());
                    }}, metadata, context);
```

_To this:_

```java
    TikaResource.parse(wrapper, LOG, info.getPath(), is, null, metadata, context);
```

_Comments: Here the ContentHandler pointer is null._

### Enjoy the Speed!


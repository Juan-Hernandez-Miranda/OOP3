# OOP3

## Ejecucion rapida

En la raiz del proyecto:

```
./mvnw spring-boot:run
```

Luego abre:

```
http://localhost:8081
```

## Problema de conexion a la base de datos

### Sintoma

El proyecto fallaba con un error tipo:

```
comunicacion con la base, de datos porque las credenciales estaban mal
```

### Causa

La aplicacion no podia conectarse a MySQL. Esto pasa si:
- MySQL no esta encendido.
- El host o puerto son incorrectos.
- El usuario o la contrasena no coinciden con la configuracion.
- La base de datos no existe.

### Solucion

1. Asegura que MySQL este encendido.
2. Verifica que la base exista (por ejemplo `agenda`).
3. Asegura que las credenciales sean correctas.
4. Revisa la configuracion en:

`src/main/resources/application.properties`

Ejemplo:

```
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/agenda?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=esta es mi contraseña
```

Si el usuario o la contrasena son distintos, cambialos ahi o usa variables de entorno.

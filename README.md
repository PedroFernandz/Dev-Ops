# DevOps Scripts 📦🚀

Este repositorio contiene una colección de scripts útiles para tareas de DevOps, como la gestión de imágenes de Docker y la migración de instancias de GitLab en contenedores Docker.

---

## 📂 Contenido del Repositorio

| Script                      | Descripción                                                                                         |
| --------------------------- | --------------------------------------------------------------------------------------------------- |
| `docker-image-puller.sh`    | Automatiza la descarga de imágenes de Docker desde un registro especificado.                      |
| `gitlab-docker-migrator.sh` | Facilita la migración de una instancia de GitLab en Docker a otro servidor o entorno.             |

---

## ⚙️ Requisitos

- **Sistemas Unix/Linux**: Estos scripts están diseñados para entornos Unix o Linux.
- **Docker**: Asegúrate de tener Docker instalado y configurado en tu sistema.
- **Permisos de ejecución**: Concede permisos de ejecución a los scripts con:
  ```bash
  chmod +x script_name.sh
  ```

---

## 🚀 Instalación

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/PedroFernandz/Dev-Ops.git
   cd Dev-Ops
   ```

---

## 📂 Contenido del Repositorio y Ejemplos de Uso

### `docker-image-puller.sh` 📥

**Descripción:**
Automatiza la descarga de imágenes de Docker desde un registro especificado, permitiendo la gestión eficiente de imágenes en entornos de desarrollo y producción.

**Ejemplo de uso:**
```bash
./docker-image-puller.sh ubuntu:latest
```
Esto descargará la imagen más reciente de Ubuntu desde Docker Hub.

**Parámetros opcionales:**
- `-r` o `--registry`: Especifica un registro personalizado desde el cual descargar la imagen.
- `-u` o `--username`: Nombre de usuario para autenticación en registros privados.
- `-p` o `--password`: Contraseña para autenticación en registros privados.

**Ejemplo con parámetros opcionales:**
```bash
./docker-image-puller.sh -r myregistry.local:5000 -u usuario -p contraseña mi-imagen:tag
```
Esto descargará la imagen `mi-imagen:tag` desde un registro privado en `myregistry.local:5000` utilizando las credenciales proporcionadas.

---

### `gitlab-docker-migrator.sh` 🛠️

**Descripción:**
Facilita la migración de una instancia de GitLab en Docker a otro servidor o entorno, asegurando que todos los datos, configuraciones y repositorios se transfieran correctamente.

**Ejemplo de uso:**
```bash
./gitlab-docker-migrator.sh --source /ruta/al/contenedor/origen --destination /ruta/al/contenedor/destino
```
Esto migrará la instancia de GitLab desde el contenedor de origen al de destino.

**Parámetros opcionales:**
- `--backup`: Realiza una copia de seguridad completa antes de iniciar la migración.
- `--restore`: Restaura una copia de seguridad en la instancia de destino.

**Ejemplo con parámetros opcionales:**
```bash
./gitlab-docker-migrator.sh --source /ruta/al/contenedor/origen --destination /ruta/al/contenedor/destino --backup
```
Esto realizará una copia de seguridad antes de migrar la instancia de GitLab al nuevo entorno.

---

> **Nota:** Asegúrate de revisar y entender cada script antes de ejecutarlo en tu sistema. Algunos scripts pueden requerir permisos de superusuario o configuraciones específicas. Además, es recomendable probar los scripts en un entorno de desarrollo antes de implementarlos en producción.

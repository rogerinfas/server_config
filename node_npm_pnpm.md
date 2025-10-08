## 📘 Guía para generar y configurar una clave SSH en Linux (Ubuntu Server)

### 1️⃣ — Verifica si ya tienes una clave existente

```bash
ls -al ~/.ssh
```

Si ves archivos como `id_rsa` o `id_ed25519`, ya tienes una.
Si no, continúa 👇

---

### 2️⃣ — Genera una nueva clave SSH

El método moderno y seguro es con **ED25519** (más rápido y seguro que RSA):

```bash
ssh-keygen -t ed25519 -C "tu_correo@ejemplo.com"
```

Si tu sistema no soporta `ed25519`, usa:

```bash
ssh-keygen -t rsa -b 4096 -C "tu_correo@ejemplo.com"
```

🔹 Luego te pedirá:

```
Enter a file in which to save the key (/home/usuario/.ssh/id_ed25519): [ENTER]
Enter passphrase (empty for no passphrase): [ENTER o una clave opcional]
```

---

### 3️⃣ — Inicia el agente SSH y agrega tu clave privada

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

### 4️⃣ — Copia tu clave pública

```bash
cat ~/.ssh/id_ed25519.pub
```

Copia todo el texto que empieza con `ssh-ed25519 ...`

---

### 5️⃣ — Agrega la clave a tu cuenta de GitHub / GitLab

* En **GitHub:**
  Ve a **Settings → SSH and GPG keys → New SSH key**
* En **GitLab:**
  Ve a **Preferences → SSH Keys → Add key**

Pega ahí tu clave pública.

---

### 6️⃣ — Prueba tu conexión

```bash
ssh -T git@github.com
```

Deberías ver:

```
Hi <tu_usuario>! You've successfully authenticated, but GitHub does not provide shell access.
```

---

### 7️⃣ — Clona tu repositorio por SSH

```bash
git clone git@github.com:usuario/repo-privado.git
```

---

¿Quieres que te genere un archivo llamado `GENERAR_SSH.md` con toda esta guía formateada en Markdown (para guardarlo en tu VPS o repo)?
Puedo hacerlo y dejarlo listo para descargar o copiar directamente.

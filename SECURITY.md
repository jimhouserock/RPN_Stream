# Security Guidelines
**Author:** Jimmy Lin

## 🔒 **Security Best Practices**

### ✅ **What's Already Secure:**
- ✅ No hardcoded secrets in repository
- ✅ Auto-generated secrets in production
- ✅ Environment variable configuration
- ✅ Non-root Docker user
- ✅ Multi-stage Docker build

### 🛡️ **Environment Variables Security:**

#### **For Local Development:**
```bash
# Copy the example file
cp .env.example .env

# Generate a secure secret key
openssl rand -hex 64

# Add to your .env file (never commit this file!)
echo "SECRET_KEY_BASE=your-generated-key" >> .env
```

#### **For Production Deployment:**
- **Dokploy**: Set environment variables in the dashboard
- **Docker**: Use `docker run -e SECRET_KEY_BASE=...`
- **Kubernetes**: Use secrets and configmaps

### 🚫 **Never Commit These Files:**
- `.env`
- `.env.local`
- `.env.production`
- `config/master.key`
- Any file containing actual secrets

### 🔑 **Secret Key Generation:**
```bash
# Generate SECRET_KEY_BASE
openssl rand -hex 64

# Generate RAILS_MASTER_KEY (if needed)
openssl rand -hex 32
```

### 📋 **Deployment Checklist:**
- [ ] Secrets set as environment variables (not in code)
- [ ] Different secrets for each environment
- [ ] `.env` files in `.gitignore`
- [ ] Regular secret rotation schedule
- [ ] Access logs monitored

### 🚨 **If Secrets Are Compromised:**
1. **Immediately** rotate all affected secrets
2. Update environment variables in all deployments
3. Review access logs for suspicious activity
4. Consider revoking and regenerating all related credentials

### 📞 **Security Contact:**
For security issues, please contact: jimmy@vibe8.app

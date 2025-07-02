# Docker Multistage Build Size Comparison

This project demonstrates the dramatic size reductions possible with Docker multistage builds across different programming languages.

## Size Comparison Results

| Language    | Traditional Build | Multistage Build | Size Reduction | Percentage Saved |
| ----------- | ----------------- | ---------------- | -------------- | ---------------- |
| **Go**      | 1.13GB            | 9.08MB           | 1.12GB         | **99.2%**        |
| **Node.js** | 1.14GB            | 130MB            | 1.01GB         | **88.6%**        |
| **Python**  | 1.34GB            | 250MB            | 1.09GB         | **81.3%**        |
| **Java**    | 1.4GB             | 297MB            | 1.10GB         | **78.8%**        |

## Key Insights

### 🎯 **Dramatic Size Reductions**

- **Go**: 99.2% size reduction (1.13GB → 9.08MB)
- **Node.js**: 88.6% size reduction (1.14GB → 130MB)
- **Python**: 81.3% size reduction (1.34GB → 250MB)
- **Java**: 78.8% size reduction (1.4GB → 297MB)

### 🔍 **Why Go Shows the Most Dramatic Reduction**

Go's static compilation produces a single binary with no runtime dependencies. When combined with multistage builds using a minimal scratch or distroless base image, this results in the most dramatic size reduction from a 1.13GB build environment to just 9.08MB.

### 💡 **Benefits of Multistage Builds**

1. **Smaller Images**: Up to 99.2% size reduction
2. **Faster Deployments**: Less data to transfer
3. **Reduced Attack Surface**: Only runtime dependencies included
4. **Better Security**: Build tools and source code not present in final image
5. **Cost Savings**: Less storage and bandwidth usage

### 🏗️ **How Multistage Builds Work**

1. **Build Stage**: Uses full development environment with all build tools
2. **Production Stage**: Copies only the compiled artifacts to a minimal runtime image
3. **Result**: Production-ready image without build dependencies

## Example Dockerfile Pattern

```dockerfile
# Build stage
FROM node:18 AS builder
COPY package*.json ./
RUN npm ci --only=production

# Production stage
FROM node:18-alpine
COPY --from=builder /app/node_modules ./node_modules
COPY . .
CMD ["node", "server.js"]
```

## Run the Examples

```bash
# Build all examples
./scripts/build-and-compare.sh

# Or build individual examples
cd nodejs && docker build -f Dockerfile -t nodejs-traditional .
cd nodejs && docker build -f Dockerfile.secure -t nodejs-multistage .
```

---

_Generated on $(date)_

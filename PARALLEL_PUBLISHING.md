# Parallel Helm Chart Publishing

Speed up chart publishing by processing multiple charts simultaneously.

## GitHub Actions (Automatic Parallel)

The workflow `.github/workflows/publish-acr-parallel.yaml` automatically publishes charts in parallel using GitHub Actions matrix strategy.

### Features

- ✅ **Up to 10 charts in parallel** - Configurable with `max-parallel`
- ✅ **Fail-safe** - One chart failure doesn't stop others
- ✅ **Smart detection** - Only publishes changed charts on push
- ✅ **Manual trigger** - Publish all or specific charts
- ✅ **Detailed summary** - See results for each chart

### How It Works

1. **Detect Charts Job** - Determines which charts need publishing
2. **Publish Jobs** - Matrix strategy creates parallel jobs for each chart
3. **Summary Job** - Aggregates results and creates summary

### Usage

#### Automatic (on push)
```bash
# Make changes to any chart
cd charts/radarr
vim Chart.yaml  # Bump version

# Commit and push - only changed charts are published in parallel
git add .
git commit -m "chore: bump radarr version"
git push
```

#### Manual Trigger

**Via GitHub Web UI:**
1. Go to **Actions** → **Publish Helm Charts to ACR (Parallel)**
2. Click **Run workflow**
3. Leave chart name empty to publish all (in parallel)
4. Or enter specific chart name

**Via GitHub CLI:**
```bash
# Publish all charts in parallel
gh workflow run publish-acr-parallel.yaml

# Publish specific chart
gh workflow run publish-acr-parallel.yaml --field chart_name=radarr
```

### Performance Comparison

| Charts | Sequential | Parallel (5 jobs) | Parallel (10 jobs) |
|--------|-----------|-------------------|-------------------|
| 1      | ~30s      | ~30s              | ~30s              |
| 5      | ~2m 30s   | ~1m               | ~1m               |
| 12     | ~6m       | ~2m 30s           | ~1m 30s           |

*Times are approximate and depend on chart size and network speed*

### Adjusting Parallelism

Edit `.github/workflows/publish-acr-parallel.yaml`:

```yaml
strategy:
  max-parallel: 10  # Change this number (1-20 recommended)
  fail-fast: false
```

**Recommendations:**
- **1-5 charts**: Use 5 parallel jobs
- **6-12 charts**: Use 10 parallel jobs
- **13+ charts**: Use 15-20 parallel jobs

## Local Parallel Publishing

### Prerequisites

Install GNU parallel:

```bash
sudo apt install parallel
```

### Using the Parallel Script

```bash
# Publish all charts with 5 parallel jobs (default)
./publish-to-acr-parallel.sh --registry t2azcr

# Publish with 10 parallel jobs
./publish-to-acr-parallel.sh --registry t2azcr --jobs 10

# Publish specific chart (no parallelism needed)
./publish-to-acr-parallel.sh --registry t2azcr --chart radarr

# Dry run
./publish-to-acr-parallel.sh --registry t2azcr --dry-run
```

### Performance Tips

**Optimal parallel jobs:**
```bash
# For 12 charts, use 5-10 jobs
./publish-to-acr-parallel.sh --registry t2azcr --jobs 8

# For fewer charts, reduce jobs
./publish-to-acr-parallel.sh --registry t2azcr --jobs 3
```

**Without GNU parallel:**
The script automatically falls back to sequential processing if `parallel` is not installed.

## Comparison: Sequential vs Parallel

### Sequential (`publish-to-acr.sh`)

**Pros:**
- ✅ No additional dependencies
- ✅ Simpler output (easier to read)
- ✅ Lower resource usage
- ✅ Better for debugging individual charts

**Cons:**
- ❌ Slower for multiple charts
- ❌ One chart blocks others

**Best for:**
- Publishing 1-3 charts
- Debugging chart issues
- Systems without GNU parallel

### Parallel (`publish-to-acr-parallel.sh` or GitHub Actions)

**Pros:**
- ✅ Much faster for multiple charts
- ✅ Charts don't block each other
- ✅ Better resource utilization
- ✅ One failure doesn't stop others

**Cons:**
- ❌ Requires GNU parallel (local) or GitHub Actions
- ❌ Interleaved output can be harder to read
- ❌ Higher resource usage

**Best for:**
- Publishing 4+ charts
- CI/CD pipelines
- Regular bulk updates

## Examples

### Example 1: Publish All Charts (Parallel)

**GitHub Actions:**
```bash
gh workflow run publish-acr-parallel.yaml
```

**Local:**
```bash
./publish-to-acr-parallel.sh --registry t2azcr --jobs 10
```

**Output:**
```
======================================
Azure Container Registry Helm Publisher
(Parallel Mode)
======================================

Registry: t2azcr.azurecr.io
Namespace: helm
Charts directory: /home/tom/vscode/helmcharts/charts
Parallel jobs: 10

Processing charts in parallel (max 10 jobs)...

[autopulse] Processing version 1.0.1
[radarr] Processing version 1.0.18
[sonarr] Processing version 1.0.18
[prowlarr] Processing version 1.1.6
[qbittorrent] Processing version 1.0.3
[lidarr] Processing version 0.2.12
[jellyseerr] Processing version 0.0.3
[overseerr] Processing version 1.0.3
[autoscan] Processing version 1.0.2
[huntarr] Processing version 0.1.9
[autopulse] ✓ Successfully published 1.0.1
[radarr] ✓ Successfully published 1.0.18
[sonarr] ✓ Successfully published 1.0.18
...
```

### Example 2: Publish Changed Charts (Automatic)

When you push changes to `charts/radarr` and `charts/sonarr`:

**GitHub Actions automatically:**
1. Detects changed charts: `radarr`, `sonarr`
2. Creates 2 parallel jobs
3. Publishes both simultaneously
4. Completes in ~30-45 seconds instead of ~1 minute

### Example 3: Mixed Success/Failure

If one chart fails, others continue:

```
[radarr] ✓ Successfully published 1.0.18
[sonarr] ✓ Successfully published 1.0.18
[prowlarr] ✗ Failed to push
[prowlarr] Error: unauthorized: authentication required
[qbittorrent] ✓ Successfully published 1.0.3
[lidarr] ✓ Successfully published 0.2.12
```

GitHub Actions summary shows:
- ✅ 4 successful
- ❌ 1 failed
- Details for each chart

## Monitoring

### GitHub Actions

View parallel execution:
1. Go to **Actions** tab
2. Click on workflow run
3. See all chart jobs running simultaneously
4. Each chart has its own log

### Local

With GNU parallel, output is line-buffered:
- Each line is prefixed with chart name
- Charts process simultaneously
- Final summary shows totals

## Troubleshooting

### GitHub Actions: "Matrix must define at least one vector"

This happens when no charts are detected. Check:
- Are there changes in `charts/` directory?
- Is the chart name correct?
- Does the chart have a `Chart.yaml`?

### Local: "parallel: command not found"

Install GNU parallel:
```bash
sudo apt install parallel
```

Or use the sequential script:
```bash
./publish-to-acr.sh --registry t2azcr
```

### Rate Limiting

If you hit ACR rate limits with too many parallel jobs:
1. Reduce `max-parallel` in GitHub Actions
2. Reduce `--jobs` in local script
3. Wait a few minutes and retry

### Authentication Errors in Parallel

All parallel jobs share the same Helm registry login. If you see auth errors:
```bash
# Re-authenticate
helm registry logout t2azcr.azurecr.io
helm registry login t2azcr.azurecr.io --username github-actions --password $PASSWORD

# Then retry
./publish-to-acr-parallel.sh --registry t2azcr --jobs 5
```

## Best Practices

1. **Use parallel for 4+ charts** - Sequential is fine for fewer
2. **Start with 5 parallel jobs** - Increase if needed
3. **Monitor ACR usage** - Watch for rate limits
4. **Use fail-fast: false** - Let all charts attempt publishing
5. **Check logs per chart** - Each has independent output
6. **Test with dry-run first** - Verify before actual push

## Migration from Sequential

No changes needed! Both workflows can coexist:

- **Keep** `publish-acr.yaml` for simple sequential publishing
- **Add** `publish-acr-parallel.yaml` for faster parallel publishing
- **Choose** which to use based on your needs

Or disable the sequential workflow:
```bash
# Rename to disable
mv .github/workflows/publish-acr.yaml .github/workflows/publish-acr.yaml.disabled
```

## Performance Tuning

### GitHub Actions

```yaml
# .github/workflows/publish-acr-parallel.yaml
strategy:
  max-parallel: 10  # Adjust based on chart count
  fail-fast: false  # Keep as false for best results
```

### Local Script

```bash
# Optimal for 12 charts
./publish-to-acr-parallel.sh --registry t2azcr --jobs 8

# For systems with limited resources
./publish-to-acr-parallel.sh --registry t2azcr --jobs 3

# For powerful systems
./publish-to-acr-parallel.sh --registry t2azcr --jobs 15
```

## Summary

| Feature | Sequential | Parallel (Local) | Parallel (GitHub) |
|---------|-----------|------------------|-------------------|
| Speed (12 charts) | ~6 min | ~2 min | ~1.5 min |
| Dependencies | None | GNU parallel | None |
| Output clarity | High | Medium | High |
| Failure isolation | No | Yes | Yes |
| Resource usage | Low | Medium | N/A |
| Best for | 1-3 charts | 4+ charts | CI/CD |

**Recommendation:** Use parallel publishing for 4+ charts, especially in CI/CD pipelines.

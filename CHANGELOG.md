# Changelog

## 2026-02-14 - Bug Fixes & Improvements

**Fixed:**
- Fixed variable inconsistency (`$log` vs `$logs` - now uses `$logs` consistently)
- Fixed load time comparison bug (was truncating to first character, breaking for times >10s)
  - Now uses `bc -l` for proper float comparison
- Added main page HTTP status checking (not just sitemap)
  - Now alerts on 4xx/5xx errors on main URL
- Added retry logic (3 attempts with 2-second delays)
  - Prevents false alarms from network blips
- Added timeout to curl commands (30s for main site, 10s for sitemap)
  - Prevents hanging on unresponsive servers
- Skip empty lines in sitelist.txt

**Improved:**
- More informative Slack messages (includes HTTP status codes, load time threshold)
- More detailed logging (includes HTTP status in OK messages)
- Separate alerts for site down vs. sitemap missing (helps diagnose DB issues)

**Not Changed:**
- Repeated alerting behavior (intentional feature - keeps alerting while site is down)
- Basic architecture (still simple BASH script)
- Configuration format
- Cron setup

**Backward Compatible:**
- No config changes required
- Existing sitelist.txt files work as-is
- Log format extended but still readable

NagiosCheck
===========

Rails gem for easy writing, testing, executing nagios checks inside Rails application.
Designed to be concurrenly, requires eventmachine webserver (~thin).

AR connections should be configured with pool: 100

All blocking IO operations should have possibility to run in threads (like: activerecord),
otherwise should use EM for checks (Nagios::CheckEM).

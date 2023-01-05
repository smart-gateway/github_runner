# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include github_runner
class github_runner(
  String $ensure = 'present',
  Array[String] $path = ['/usr/local/sbin','/usr/local/bin','/usr/sbin','/usr/bin','/sbin','/bin'],
  String $runner_user,
  String $runner_url,
  String $runner_token,
  String $runner_dir = '/opt/actions-runner',
  String $runner_version = '2.299.1',
  String $runner_archive_hash = '147c14700c6cb997421b9a239c012197f11ea9854cd901ee88ead6fe73a72c74',
) {
  # Ensure class declares subordinate classes
  contain github_runner::install
  contain github_runner::config
  contain github_runner::service

  # Ensure execution ordering
  anchor { '::github_runner::begin': }
  -> Class['::github_runner::install']
  -> Class['::github_runner::config']
  -> Class['::github_runner::service']
  -> anchor { '::github_runner::end': }
}

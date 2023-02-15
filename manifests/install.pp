# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include github_runner::install
class github_runner::install {
  case $github_runner::ensure {
    'present', 'installed': {

      # Ensure that the runners directory exists
      file { 'ensure the runner directory exists':
        ensure => directory,
        path   => $::github_runner::runner_dir,
        owner  => $::github_runner::runner_user,
        group  => $::github_runner::runner_user,
      }

      # Download the installer
      exec { 'download the github actions runner installer':
        command => "curl -o ${::github_runner::runner_dir}/actions-runner-linux-x64-${::github_runner::runner_version}.tar.gz -L https://github.com/actions/runner/releases/download/v${::github_runner::runner_version}/actions-runner-linux-x64-${::github_runner::runner_version}.tar.gz",
        path    => $::github_runner::path,
        unless  => "test -f ${::github_runner::runner_dir}/.runner",
      }

      # Extract the runner
      exec { 'extract the github actions runner':
        command => "tar xzf ${::github_runner::runner_dir}/actions-runner-linux-x64-${::github_runner::runner_version}.tar.gz -C ${::github_runner::runner_dir}",
        path    => $::github_runner::path,
        onlyif  => "echo '${::github_runner::runner_archive_hash} ${::github_runner::runner_dir}/actions-runner-linux-x64-${::github_runner::runner_version}.tar.gz' | shasum -a 256 -c",
        unless  => "test -f ${::github_runner::runner_dir}/.runner",
      }

      # Configure the runner
      exec { 'configure the github actions runner':
        command  => "/opt/actions-runner/config.sh --url ${::github_runner::runner_url} --token ${::github_runner::runner_token} --unattended",
        path     => $::github_runner::path,
        provider => shell,
        user     => "${::github_runner::runner_user}",
        unless   => "test -f ${::github_runner::runner_dir}/.runner",
      }
    }

    'absent', 'purged': {

    }

    'disabled': {

    }

    default: {
      notify { "Unknown 'ensure' value: ${github_runner::ensure}": }
    }
  }
}

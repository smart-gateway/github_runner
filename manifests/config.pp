# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include github_runner::config
class github_runner::config {
  case $github_runner::ensure {
    'present', 'installed': {

      # Install the runner service
      exec { 'install the github actions runner service':
        command => "/opt/actions-runner/svc.sh install ${::github_runner::runner_user}",
        path    => $::github_runner::path,
        cwd     => $::github_runner::runner_dir,
        onlyif  => "${::github_runner::runner_dir}/svc.sh status | grep -q 'not installed'",
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

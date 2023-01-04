# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include github_runner::service
class github_runner::service {
  case $github_runner::ensure {
    'present', 'installed': {

      # ensure runner service is running
      exec { 'ensure the github actions runner is running':
        command => "${::github_runner::runner_dir}/svc.sh start",
        path    => $::github_runner::path,
        cwd     => $::github_runner::runner_dir,
        unless  => "${::github_runner::runner_dir}/svc.sh status | grep -q 'active (running)'",
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

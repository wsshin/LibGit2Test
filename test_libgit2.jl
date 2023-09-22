using LibGit2

repo_path = joinpath(ENV["JULIA_PKG_DEVDIR"], "LibGit2Test")
repo = LibGit2.GitRepo(repo_path)
LibGit2.add!(repo, ".")
LibGit2.commit(repo, "Commit changes")

remote = LibGit2.GitRemoteAnon(repo, "git@github.com:wsshin/LibGit2Test.git")
LibGit2.push(remote, "refs/heads/main")

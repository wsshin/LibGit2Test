using LibGit2

repo_path = joinpath(ENV["JULIA_PKG_DEVDIR"], "LibGit2Test")
repo = LibGit2.GitRepo(repo_path)
LibGit2.add!(repo, ".")
LibGit2.commit(repo, "Commit changes")

rmt = LibGit2.lookup_remote(repo, "origin")
LibGit2.push(rmt, ["refs/heads/main"])

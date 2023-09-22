using LibGit2

repo_path = joinpath(ENV["JULIA_PKG_DEVDIR"], "LibGit2Test")
repo = LibGit2.GitRepo(repo_path)
LibGit2.add!(repo, ".")
LibGit2.commit(repo, "Commit changes")

rmt = LibGit2.lookup_remote(repo, "origin")
LibGit2.add_push!(repo, rmt, "refs/heads/main")
options = LibGit2.PushOptions()


# sshcreds = LibGit2.SSHCredential()
# sshcreds.user = "wsshin"
# sshcreds.prvkey = joinpath(ENV["HOME"], ".ssh", "id_rsa")
# sshcreds.pubkey = joinpath(ENV["HOME"], ".ssh", "id_rsa.pub")

LibGit2.push(rmt, ["refs/heads/main"]; options)

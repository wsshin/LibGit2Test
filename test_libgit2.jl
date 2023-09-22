using LibGit2

repo_path = joinpath(ENV["JULIA_PKG_DEVDIR"], "LibGit2Test")
repo = LibGit2.GitRepo(repo_path)
LibGit2.add!(repo, ".")
LibGit2.commit(repo, "Commit changes")

# Try to mimic LibGit2.jl > function push(repo; ...), which tries to automatize a lot.


rmt = LibGit2.lookup_remote(repo, "origin")

sshcreds = LibGit2.SSHCredential()
sshcreds.user = "wsshin"
sshcreds.prvkey = joinpath(ENV["HOME"], ".ssh", "id_rsa")
sshcreds.pubkey = joinpath(ENV["HOME"], ".ssh", "id_rsa.pub")

cred_payload = LibGit2.reset!(LibGit2.CredentialPayload(sshcreds), LibGit2.GitConfig(repo))

callbacks = LibGit2.Callbacks()
callbacks[:credentials] = (LibGit2.credentials_cb(), cred_payload)

remote_callbacks = LibGit2.RemoteCallbacks(callbacks)
push_opts = PushOptions(callbacks=remote_callbacks)

LibGit2.push(rmt, ["refs/heads/main"], force=force, options=push_opts)

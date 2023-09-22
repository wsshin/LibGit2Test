using LibGit2

repo_path = joinpath(ENV["JULIA_PKG_DEVDIR"], "LibGit2Test")
repo = LibGit2.GitRepo(repo_path)
LibGit2.add!(repo, ".")
LibGit2.commit(repo, "Commit changes")

credentials = LibGit2.SSHCredential()
credentials.prvkey = joinpath(ENV["HOME"], ".ssh", "id_rsa")
credentials.pubkey = joinpath(ENV["HOME"], ".ssh", "id_rsa.pub")

rmt = LibGit2.lookup_remote(repo, "origin")
refspecs = LibGit2.push_refspecs(rmt)
LibGit2.push(repo; refspecs=["refs/heads/main"], credentials)

# How I came up with the above working code
#
# I tried many things, but the code always complained about lacking callbacks.  Callbacks
# seemed to be related to credentials.
#
# There were some examples about username/password credentials, but not much about SSH key
# pair.  So, I search for "SSH" in LibGit2, and found an example usage in
# LibGit2/test/libgit2-tests.jl.  That's how I had an idea about creating sshcreds.  I
# initially set sshcreds.user = "wsshin", but eventually push() complained something about
# the username, so I removed it, and it worked.
#
# A bigger issue was callbacks.  It seemed difficult to implement callbacks myself, so I
# hoped there would ones already implemented.  I searched for "callbacks" in LibGit2/src/,
# and found that I have many occurrences in callbacks.jl.  The functions there looked
# complicated, taking Ptr.  Then, I found that credentials_cb() seems to be building some
# default callbacks.
#
# Then I wanted to know how this pre-constructed callbacks are used.  When I searched for
# credentials_cb(), I found that it is used in LibGit2.jl/push(repo; ...).  The function
# seemed to automatize lots of things for the users, so I decided to mimic the contents of
# the function.  Eventually, I came up with the following code that worked.
#
# This meant that push(repo; ...) does almost what I wanted to do.  I was wondering if I
# could pass right inputs to the function, and I found that the above code was working.

# rmt = LibGit2.lookup_remote(repo, "origin")  # not documented, but found it while trying to mimic https://stackoverflow.com/questions/28055919/how-to-push-with-libgit2
#
# sshcreds = LibGit2.SSHCredential()
# sshcreds.prvkey = joinpath(ENV["HOME"], ".ssh", "id_rsa")
# sshcreds.pubkey = joinpath(ENV["HOME"], ".ssh", "id_rsa.pub")
#
# cred_payload = LibGit2.reset!(LibGit2.CredentialPayload(sshcreds), LibGit2.GitConfig(repo))
#
# callbacks = LibGit2.Callbacks()
# callbacks[:credentials] = (LibGit2.credentials_cb(), cred_payload)
#
# remote_callbacks = LibGit2.RemoteCallbacks(callbacks)
# push_opts = LibGit2.PushOptions(callbacks=remote_callbacks)
#
# LibGit2.push(rmt, ["refs/heads/main"], options=push_opts)

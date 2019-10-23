"Ultimately the whole point of a permission set is to separate things. Why should Dojo have access to install system drivers? Why should Tor be able to edit Dojo's database? Stuff like that. Ultimately I'd say it's worth it, if not just for good practices. Having a user with an ssh key is good practice, but then requiring their own credentials (sudo -> root) is just another barrier in case a malicious actor gets into your system.

We disable the root account because it is a matter of the principle of least privilege, there's no point running as root when you don't have to. The difference is relatively slim when dealing with a node that only has one purpose and one user. You can argue that if your user is compromised there might be some security, but with an interactive compromised user this is limited. From my understanding (compromised user -> evil maid attack -> root)".

- @Nicholas

---
date: 2021-10-04
title: Viewing Bazel logs using LNAV
tags:
  - Linux
---

Bazel doesn't support streaming logs to the terminal, which means that long Bazel builds are about as fun as watching paint dry. Fair enough - you shouldn't be there babysitting your builds anyway - but sometimes a little more information is nice to see, especially when developing a new rule.

While it's possible to `tail -f` or `less +F` the files in `bazel-out/_tmp/actions`, it can be annoying to deal with output of rules you don't currently care about. This is where [LNAV][lnav], the log file navigator comes in.

It allows you to interact with your log files, switch between them, and scroll back regardless of your terminal emulator's scrollback settings.

For use with Bazel, invoking as `lnav bazel-out/_tmp/actions` will launch LNAV watching the stdout and stderr transcripts of your currently running jobs.

[lnav]: https://lnav.org

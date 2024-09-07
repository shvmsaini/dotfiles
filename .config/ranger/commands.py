from ranger.api.commands import Command

class paste_as_root(Command):
	def execute(self):
		if self.fm.do_cut:
			self.fm.execute_console('shell sudo mv %c .')
		else:
			self.fm.execute_console('shell sudo cp -r %c .')

# use fzf in ranger gxt_kt
class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """
    def execute(self):
        import subprocess
        import os.path
        if self.quantifier:
            # match only directories
            command='fd --type d --hidden --follow --exclude={.wine,.git,.idea,.vscode,node_modules,build} | fzf +m'
        else:
            # match files and directories
            command='fd --hidden --follow --exclude={.wine,.git,.idea,.vscode,node_modules,build} | fzf +m'
        fzf = self.fm.execute_command(command, universal_newlines=True, stdout=subprocess.PIPE)
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip('\n'))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)

#class fzf_select(Command):
#    """
#    :fzf_select
#    Find a file using fzf.
#    With a prefix argument to select only directories.
#
#    See: https://github.com/junegunn/fzf
#    """
#
#    def execute(self):
#        import subprocess
#        import os
#        from ranger.ext.get_executables import get_executables
#
#        if 'fzf' not in get_executables():
#            self.fm.notify('Could not find fzf in the PATH.', bad=True)
#            return
#
#        fd = None
#        if 'fdfind' in get_executables():
#            fd = 'fdfind'
#        elif 'fd' in get_executables():
#            fd = 'fd'
#
#        if fd is not None:
#            hidden = ('--hidden' if self.fm.settings.show_hidden else '')
#            exclude = "--no-ignore-vcs --exclude '.git' --exclude '*.py[co]' --exclude '__pycache__'"
#            only_directories = ('--type directory' if self.quantifier else '')
#            fzf_default_command = '{} --follow {} {} {} --color=always'.format(
#                fd, hidden, exclude, only_directories
#            )
#        else:
#            hidden = ('-false' if self.fm.settings.show_hidden else r"-path '*/\.*' -prune")
#            exclude = r"\( -name '\.git' -o -name '*.py[co]' -o -fstype 'dev' -o -fstype 'proc' \) -prune"
#            only_directories = ('-type d' if self.quantifier else '')
#            fzf_default_command = 'find -L . -mindepth 1 {} -o {} -o {} -print | cut -b3-'.format(
#                hidden, exclude, only_directories
#            )
#
#        env = os.environ.copy()
#        env['FZF_DEFAULT_COMMAND'] = fzf_default_command
#        env['FZF_DEFAULT_OPTS'] = '--height=100% --layout=reverse --ansi --preview="{}"'.format('''
#            (
#                batcat --color=always {} ||
#                bat --color=always {} ||
#                cat {} ||
#                tree -ahpCL 3 -I '.git' -I '*.py[co]' -I '__pycache__' {}
#            ) 2>/dev/null | head -n 100
#        ''')
#
#        fzf = self.fm.execute_command('fzf --no-multi', env=env,
#                                      universal_newlines=True, stdout=subprocess.PIPE)
#        stdout, _ = fzf.communicate()
#        if fzf.returncode == 0:
#            selected = os.path.abspath(stdout.strip())
#            if os.path.isdir(selected):
#                self.fm.cd(selected)
#            else:
#                self.fm.select_file(selected)

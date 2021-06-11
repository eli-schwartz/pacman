scripts = {
  'makepkg-template.pl.in': false,
  'makepkg.sh.in': true,
  'pacman-db-upgrade.sh.in': true,
  'pacman-key.sh.in': true,
  'repo-add.sh.in': true,
}

SCRIPT_EDITOR = find_program(configure_file(
  input : join_paths(meson.source_root(), 'build-aux/edit-script.sh.in'),
  output : 'edit-script.sh',
  configuration : substs))

script_wrappers = []
foreach script, wrapped : scripts
  script_shortname = script.split('.')[0]

  internal_script = custom_target(
    script_shortname,
    input : script,
    command : [ SCRIPT_EDITOR, '@INPUT@', '@OUTPUT@', '0755'],
    output : script_shortname,
    install : true,
    install_dir : BINDIR)

  if wrapped
    script_wrappers += [[ script_shortname, internal_script, meson.current_build_dir() ]]

    if script_shortname == 'repo-add'
      repo_add = internal_script
    endif
  endif
endforeach

foreach symlink : ['repo-remove', 'repo-elephant']
  meson.add_install_script(MESON_MAKE_SYMLINK,
                           'repo-add',
                           join_paths(BINDIR, symlink))

  internal_script = custom_target(
    symlink,
    build_by_default : true,
    command : ['ln', '-sf', 'repo-add', '@OUTPUT@'],
    depends : repo_add,
    output : symlink)

  script_wrappers += [[ symlink, internal_script, meson.current_build_dir() ]]
endforeach

subdir('libmakepkg')

configure_file(
	configuration : { 'libmakepkgdir': LIBMAKEPKGDIR, 'PACKAGE_VERSION': PACKAGE_VERSION },
	input : 'libmakepkg.pc.in',
	output : '@BASENAME@',
	install_dir : join_paths(DATAROOTDIR, 'pkgconfig'))

custom_target(
  'bash_completion',
  command : [ SCRIPT_EDITOR, '@INPUT@', '@OUTPUT@' ],
  input : 'completion/bash_completion.in',
  output : 'pacman',
  install : true,
  install_dir : BASHCOMPDIR)

foreach symlink : ['pacman-key', 'makepkg']
  meson.add_install_script(MESON_MAKE_SYMLINK,
                           'pacman',
                           join_paths(BASHCOMPDIR, symlink))
endforeach

zsh_completion_dir = join_paths(DATAROOTDIR, 'zsh/site-functions')
custom_target(
  'zsh_completion',
  command : [ SCRIPT_EDITOR, '@INPUT@', '@OUTPUT@' ],
  input : 'completion/zsh_completion.in',
  output : '_pacman',
  install : true,
  install_dir : zsh_completion_dir)

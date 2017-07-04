function exec_cmd() {
	echo '========================================='
	echo "$@"
	echo '========================================='
	$@
}

function install_rails_via_tmp_gemfile() {
	local gem_path=/tmp/tmg_gem/
	rm -rf "$gem_path"
	mkdir -p "$gem_path"
	cat Gemfile | awk "{ if(match(\$0, /.*gem .*'rails'.*,.*'(~> [0-9]+.[0-9]+.[0-9]+)/, vers)) print \$0}" > "$gem_path/Gemfile"
	cp .ruby-gemset "$gem_path/"
	pushd "$gem_path"
	exec_cmd bundle install
	popd
	rm -rf "$gem_path"
}

function install_rails_by_gemfile() {
	ver=$(cat Gemfile | awk "{ if(match(\$0, /'rails'.*,.*'([0-9]+.[0-9]+.[0-9]+)/, vers)) print vers[1]}")
	if [ ! -z "$ver" ]; then
		exec_cmd gem install rails -v $ver
	else
		install_rails_via_tmp_gemfile
	fi
}

function set_default_ruby_rails_ver() {
	if [ "$(basename $(pwd))" == "default" ]; then
		ver=$(cat .ruby-version)
		ver=${ver/ruby-/}
		exec_cmd rvm use ${ver} --default 
		exec_cmd rvm use ${ver}@$(cat .ruby-gemset) --default
	fi
}

for path in $(ls -d $1/*)
do
	pushd "$path"
		exec_cmd rvm install $(cat .ruby-version)
	popd
	pushd "$path"
		if [ -f Gemfile.lock ]; then
			ver=$(cat Gemfile.lock | awk '{ if(match($0, / rails \(([0-9]+\.[0-9]+\.[0-9]+)\)/, vers)) print vers[1]}')
			if [ ! -z "$ver" ]; then
				exec_cmd gem install rails -v $ver
			else
				install_rails_by_gemfile
			fi
		else
			install_rails_by_gemfile
		fi
		set_default_ruby_rails_ver
	popd
done

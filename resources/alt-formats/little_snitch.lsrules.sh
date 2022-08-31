#!/bin/sh

# Author:     Héctor Molinero Fernández <hector@molinero.dev>
# License:    MIT, https://opensource.org/licenses/MIT
# Repository: https://github.com/hectorm/hblock

set -eu
export LC_ALL='C'

main() {
	source="${1:?}"
	target="${2:?}"
	hblock="${3:-hblock}"

	export HBLOCK_HEADER="$(cat <<-'EOF'
	{
		"name": "hBlock default block list",
		"description": "hBlock is a POSIX-compliant shell script that gets a list of domains that serve ads, tracking scripts and malware from multiple sources and creates a hosts file, among other formats, that prevents your system from connecting to them.\n\n(https:\/\/github.com\/hectorm\/hblock)",
		"denied-remote-domains": [
	EOF
	)"
	export HBLOCK_FOOTER="$(cat <<-'EOF'
		]
	}
	EOF
	)"
	export HBLOCK_SOURCES="file://${source:?}"
	export HBLOCK_ALLOWLIST=''
	export HBLOCK_DENYLIST='hblock-check.molinero.dev'

	export HBLOCK_REDIRECTION=''
	export HBLOCK_WRAP='1'
	export HBLOCK_TEMPLATE='"%D",'
	export HBLOCK_COMMENT=''

	export HBLOCK_LENIENT='false'
	export HBLOCK_REGEX='false'
	export HBLOCK_FILTER_SUBDOMAINS='false'
	export HBLOCK_CONTINUE='false'

	"${hblock:?}" -qO- | awk '$1 == "]"{sub(/,$/, "", s)} NR>1{print s} {s=$0} END{print s}' > "${target:?}"
}

main "${@-}"

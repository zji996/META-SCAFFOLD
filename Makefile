.PHONY: check package link-pi-local sync-global refresh-global

check:
	./scripts/check.sh

link-pi-local:
	pi install "$(CURDIR)"

sync-global:
	./scripts/install-agent-skill.sh all

refresh-global:
	META_SCAFFOLD_FORCE_INSTALL=1 ./scripts/install-agent-skill.sh all

package:
	cd .. && zip -r META-SCAFFOLD.zip META-SCAFFOLD -x 'META-SCAFFOLD/.git/*'

.PHONY: check sync package link-pi-local sync-global link-global refresh-global

check:
	./scripts/check.sh

sync:
	./scripts/sync-dist.sh

link-pi-local:
	pi install "$(CURDIR)"

sync-global:
	./scripts/install-agent-skill.sh all

link-global:
	./scripts/install-agent-skill.sh --link --force all

refresh-global:
	./scripts/install-agent-skill.sh --copy --force all

package:
	cd .. && zip -r META-SCAFFOLD.zip META-SCAFFOLD -x 'META-SCAFFOLD/.git/*'

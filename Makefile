.PHONY: check package

check:
	./scripts/check.sh

package:
	cd .. && zip -r META-SCAFFOLD.zip META-SCAFFOLD -x 'META-SCAFFOLD/.git/*'

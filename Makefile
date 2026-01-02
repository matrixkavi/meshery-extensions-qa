# Copyright Meshery Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include build/Makefile.core.mk
include build/Makefile.show-help.mk

#-----------------------------------------------------------------------------
# Docker-based Builds
#-----------------------------------------------------------------------------
.PHONY: generate-report


# --------------------------------------------------
# Helpers
# --------------------------------------------------

define sync_results
	@rm -rf $(2)
	@mkdir -p $(2)
	@if [ -n "$($(1))" ] && [ -d "$($(1))" ]; then \
		echo "Copying results from $($(1)) → $(2)"; \
		cp -r "$($(1))"/* $(2)/; \
	else \
		echo "$(1) not set or directory does not exist, skipping"; \
	fi
endef

# --------------------------------------------------
# Targets
# --------------------------------------------------

sync-kanvas-results: ## Sync Kanvas Test Results
	@echo "Syncing Kanvas Test Results..."
	$(call sync_results,KANVAS_RESULTS_PATH,kanvas-results)

sync-meshery-results: ## Sync Meshery Test Results
	@echo "Syncing Meshery Test Results..."
	$(call sync_results,MESHERY_RESULTS_PATH,meshery-results)

sync-remote-provider-results: ## Sync Remote Provider Test Results
	@echo "Syncing Remote Provider Test Results..."
	$(call sync_results,REMOTE_PROVIDER_RESULTS_PATH,remote-provider-results)


generate-report: ## Generate QA Report
	@echo "Generating QA Report..."
	rm -rf allure-results || true
	mkdir -p allure-results
	cp kanvas-results/* allure-results/ || true
	npm run report:generate

open-report: generate-report ## Open QA Report
	@echo "Opening QA Report..."
	npm run report:open

# 2. Keep Addons in Umbrella

Date: 2023-03-16

## Status

Draft

## Context

As part of the Big Bang 2.0 efforts we sought out to improve the customer experience surrounding addons and upgrades. Two of the biggest benefits we were looking for include:
- Allow customer updates to addons "at-will": Customers have a pain point when it comes to a BB version update, which can update 10-15 packages all at once. Allow incremental updates/updates at the speed of release allows them to choose their pace, and updating as quickly as needed for security patches.
- Provide the "addon" experience for community packages: Deploying a community package is painful today, and not standardized. Deploying an addon is far easier. If we could provide this "ease of deployment" for users that would help to increase adoption of community packages.

The initial thought on how to get to these goals was to decouple the addon packages from the Big Bang umbrella, which lead to a spike that several members of the team have spent time looking at (see [here](https://repo1.dso.mil/big-bang/bigbang/-/issues/1457) for further context/comments). This spike has largely produced two leading opinions on the path forward.

### "Nested Helmrelease"

Wrap each addon in a "generic" helmrelease so that the umbrella does not need package specific knowledge, but can pass down enough values for the package to configure as it does in 1.x.

Benefits:
- Every package could leverage the new "addon methodology" for deployment, and do it entirely via values passed to the Umbrella chart + templates in their package chart.
- Work involved on the developer side is *relatively* trivial for templating/logic changes, templates could be copied from the umbrella to the package with little modification needed.
- Our CI/Release testing burden would be eased since we would only be releasing bundles of core packages, with addons being tested more direclty in conjunction with only core packages

Drawbacks:
- Upgrades for customers would be incredibly messy due to "ownership" of helmreleases changing. This would roughly result in a delete/replace for any existing addons, causing customers a lot of upgrade churn + the potential for BB dev support especially on internal P1 upgrades.
- This method would increase cluster "bloat" and inhibit troubleshooting/visibility. Rather than having a single umbrella chart you are effectively switching to an umbrella + an umbrella per addon.
- The work required to get CI, release testing/R2D2, docs-compiler, and other tooling ready to support this change would be significant. This is largely still undefined/unexplored but removing a major part of the umbrella would have cascading effects to a lot of our processes.
- This cannot be completed in 2 weeks. Our initial intent was to cut the 2.0 release by the end of March, which would not be possible with the amount of remaining unknowns and work involved here.
- Does not actually solve the problem of encouraging customers to update faster. Customers would potentially update slower because they are no longer "forced" into an update every two weeks.
- Generally viewed as a stepping stone towards a better implementation programatically (operator/controller). This is a lot of work/churn for a temporary solution.

### Keep Addons in Umbrella (for the time being)

Rather than go forward with the addon splitoff, focus on achieving the above benefits in a different way. Provide the "addon" experience via the existing `packages` values/code, and provide speedier updates by leveraging the Flux notification controller and/or Renovate in customer environments.

Benefits:
- Potential to get 2.0 out the door "on time".
- Able to provide customers with an addon experience for their community packages as a new feature rather than a breaking change for existing addon packages.
- Focuses more directly on the issue of customer upgrade delays by providing them with upgrade automation/notifications in their environment/configuration. Automation/notifications would also be a new feature rather than a breaking change.
- Reduces the 2.0 breaking changes to almost entirely "values" translations (swapping enabled packages based on new default core, changing package values based on standardization, etc).
- Very few (or no) immediate changes required for CI/release process.
- BB devs will have far more limited support required from customers, freeing us up to look towards other issues and the longterm solution of an operator/controller.

Drawbacks:
- Upgrades to packages that require changes in umbrella would need a patch release of umbrella in order to provide those upgrades to customers immediately.
- Customers would be missing the connection piece between umbrella config and package config, unless we provide additional examples/modifications to existing `packages` code.
- CI/Release testing would still involve testing all packages. 

## Decision

Keep Addons in Umbrella for the time being and focus on releasing configuration for the Flux notification controller and/or Renovate in 2.0 to speed up customer updates.

## Consequences

As mentioned in the above drawbacks, this decision is not without its consequences.

As mentioned since we would not be leveraging any "extra packages" solution for our own addons we will need to consider the missing links for the customer experience. We should still be able to fill those gaps, without altering the current addon deployments, but it will require changes to `packages` and documentation on the nested helmrelease example.

Since the release testing and CI processes will continue to include all packages, we will need to be aware that those areas will continue to draw chunks of our time away from other development. However, since we will not have as much need to support customers through the upgrade / troubleshoot other issues, our time will be more freed up to find other ways to optimize these processes and implement changes in those areas instead.

This will also help to mitigate the other drawback identified - that we may need to support more frequent releases in order to provide customers with the updates they need as fast as possible. If we are improving the CI/release process we can trim the time involved here down. Improvements in CI/release testing can be done at any point in time, which keeps us from the rush of needing to complete changes before 2.0.

The final consequence is that we are seemingly abandoning work that several people have invested time in, in order to pivot to a new problem. In light of this effort being a spike, this was a very possible consequence from the beginning. We did gain valuable insight from the POC work, which not only informed this ADR but also positions us better to understand the problem and tackle it with a different solution in the future. We also were able to "stress test" a number of the new 2.0 features with `packages` and discover other issues we need to resolve.

While there are consequences to this decision, the benefits outweigh them and we will ultimately be better positioned to solve customer and developer problems better in the future as a result of it.

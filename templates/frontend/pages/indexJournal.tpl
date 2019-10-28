{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * Copyright (c) 2018-2019 Vitalii Bezsheiko
 * Distributed under the GNU GPL v3.
 *
 * @brief Journal landing page
 *
 *}

{extends "frontend/layouts/general.tpl"}

{* passing variable *}
{assign var="pageTitleTranslated" value=$currentJournal->getLocalizedName()}

{block name="pageContent"}
	{if !empty($latestIssues)}
		<section class="box_primary">
			<div class="container carousel-container">
				<div id="carouselIssues"
				     class="carousel slide carousel-fade{if $issue->getLocalizedDescription()} carousel-with-caption{/if}"
				     data-ride="carousel">
					<div class="carousel-inner">
						{foreach from=$latestIssues item=issue key=latestKey}
							<div class="carousel-item{if $latestKey==0} active{/if}">
								{if $issue->getLocalizedCoverImageUrl()}
									{assign var="coverUrl" value=$issue->getLocalizedCoverImageUrl()}
								{else}
									{assign var="coverUrl" value=$defaultCoverImageUrl}
								{/if}
								<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}"
								   class="carousel-img">
									<img src="{$coverUrl}"
									     class="img-fluid d-block{if !$issue->getLocalizedDescription()} m-auto{/if}"{if $issue->getLocalizedCoverImageAltText()} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
								</a>
								{if $issue->getLocalizedDescription()}
									<div class="carousel-caption">
										<a class="caption-header"
										   href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
											<h5>{$issue->getIssueIdentification()|escape}</h5>
										</a>

										<div class="carousel-text">
											{$issue->getLocalizedDescription()|strip_tags|nl2br}
										</div>
									</div>
								{/if}
							</div>
						{/foreach}
					</div>

					{if $latestIssues|count > 1}
						<a class="carousel-control-prev" href="#carouselIssues" role="button" data-slide="prev">
							<span class="carousel-control-prev-icon" aria-hidden="true"></span>
							<span class="sr-only">{translate key="help.previous"}</span>
						</a>
						<a class="carousel-control-next" href="#carouselIssues" role="button" data-slide="next">
							<span class="carousel-control-next-icon" aria-hidden="true"></span>
							<span class="sr-only">{translate key="help.next"}</span>
						</a>
					{/if}
				</div>
			</div>
		</section>
	{/if}

	{if ($numAnnouncementsHomepage && $announcements|@count) || $showSummary}
		<section class="container index-journal__announcements">
			<div class="row">
				<h2 class="list-content__title col-md-12">
					{translate key="announcement.announcements"}
				</h2>
				{if ($numAnnouncementsHomepage && $announcements|@count)}
					{foreach name=announcements from=$announcements item=announcement}
						{if $smarty.foreach.announcements.iteration > $numAnnouncementsHomepage}
							{break}
						{/if}

						{if $smarty.foreach.announcements.iteration == 1}
							<article class="list-content__announcement first col-md-6">
								<h3 class="list-content__announcement-title">
									<a class="list-content__announcement-link"
									   href="{url page="announcement" op="view" path=$announcement->getId()}">
										{$announcement->getLocalizedTitle()|escape}
									</a>
									<small class="mt-2 text-muted d-block">
										{$announcement->getDatePosted()}
									</small>
								</h3>
								{if $announcement->getLocalizedDescriptionShort()}
									<div class="list-content__announcement-description">
										{$announcement->getLocalizedDescriptionShort()|strip_unsafe_html}
									</div>
								{elseif $announcement->getLocalizedDescription()}
									<div class="list-content__announcement-description">
										{$announcement->getLocalizedDescription()|strip_unsafe_html|truncate:500:"..."}
									</div>
								{/if}
							</article>
						{/if}
						{if $smarty.foreach.announcements.iteration == 2}
							<ul class="list-content col-md-6">
							{assign var="moreThanOneAnnouncement" value=true}
						{/if}

						{if $smarty.foreach.announcements.iteration > 1}
							<li class="list-content__announcement">
								<h3 class="list-content__announcement-title">
									<a class="list-content__announcement-link"
									   href="{url page="announcement" op="view" path=$announcement->getId()}">
										{$announcement->getLocalizedTitle()|escape}
									</a>
									<small class="mt-2 text-muted d-block">
										{$announcement->getDatePosted()}
									</small>
								</h3>
							</li>
						{/if}
					{/foreach}
					{if $moreThanOneAnnouncement}
						</ul>
					{/if}
				{/if}

				{if $showSummary}
					<div class="col-md-6">
						{$currentJournal->getSetting("journalSummary")}
					</div>
				{/if}
			</div>
		</section>
	{/if}

	{if !empty($publishedArticles) && !empty($popularArticles)}
		<section class="container">
			<div class="row justify-content-center">
				{if !empty($publishedArticles)}
					<ul class="list-content col-md-6">
						<h2 class="list-content__title">{translate key="plugins.gregg.latest"}</h2>
						{foreach from=$publishedArticles item="publishedArticle" key="number"}
							<li class="list-content__article">
								{if $publishedArticle->getLocalizedTitle()}
									<h3 class="list-content__article-title">
										<a class="list-content__article-link"
										   href="{url page="article" op="view" path=$publishedArticle->getBestArticleId()}">
											{$publishedArticle->getLocalizedTitle()|escape}
										</a>
									</h3>
								{/if}
								{if !empty($publishedArticle->getAuthors())}
									<ul class="list-content__article-authors">
										{foreach from=$publishedArticle->getAuthors() item="publishedAuthor"}
											<li class="list-content__article-author">
												{if $publishedAuthor->getLocalizedFamilyName()}
													<span>{$publishedAuthor->getLocalizedFamilyName()|escape}</span>
												{else}
													<span>{$publishedAuthor->getLocalizedGivenName()|escape}</span>
												{/if}
												{if $publishedAuthor->getLocalizedFamilyName() && $publishedAuthor->getLocalizedGivenName()}
													<span>{$publishedAuthor->getLocalizedGivenName()|escape|substr:0:1|strtoupper}.</span>
												{/if}
											</li>
										{/foreach}
										<small class="d-block text-muted mt-2">{translate key="submissions.published"}
											: {$publishedArticle->getDatePublished()|date_format:$dateFormatShort}</small>
									</ul>
								{/if}
							</li>
						{/foreach}
					</ul>
				{/if}

				{if !empty($popularArticles)}
					<ul class="list-content col-md-6">
						<h2 class="list-content__title">{translate key="plugins.gregg.most-viewed"}</h2>
						{foreach from=$popularArticles item="popularArticle" key="popularNumber"}
							<li class="list-content__article">
								{if $popularArticle["localized_title"]}
									<h3 class="list-content__article-title">
										<a class="list-content__article-link"
										   href="{url page="article" op="view" path=$popularNumber}">
											{$popularArticle["localized_title"]|escape}
										</a>
									</h3>
								{/if}
								{if array_key_exists('authors', $popularArticle)}
									<ul class="list-content__article-authors">
										{foreach from=$popularArticle['authors'] item="popularAuthor"}
											<li class="list-content__article-author">
												{if $popularAuthor['family_name']}
													<span>{$popularAuthor['family_name']|escape}</span>
												{else}
													<span>{$popularAuthor['given_name']|escape}</span>{if !$popularAuthor@last},{/if}
												{/if}
												{if $popularAuthor['family_name'] && $popularAuthor['given_name']}
													<span>{$popularAuthor['family_name']|escape|substr:0:1|strtoupper}
													.</span>{if !$popularAuthor@last},{/if}
												{/if}
											</li>
										{/foreach}
										<small class="d-block text-muted mt-2">{translate key="submissions.published"}
											: {$popularArticle['date_published']|date_format:$dateFormatShort}</small>
									</ul>
								{/if}
							</li>
						{/foreach}
					</ul>
				{/if}
			</div>
		</section>
	{/if}

	{if !empty($categories) && $numCategoriesHomepage}
		{foreach from=$categories item=category key=numCategory}
			{if $numCategory+1 > $numCategoriesHomepage}
				{break}
			{/if}
			<section class="container index-journal__categories">
				<div class="row">

					<div class="col-md-4">
						<h2 class="index-journal__categories-title">{$category->getLocalizedTitle()|escape}</h2>
					</div>

					{if $category->getImage()}
						<div class="col-md-8 index-journal__categories-img-wrapper">
							<img src="{url router=$smarty.const.ROUTE_PAGE page="catalog" op="fullSize" type="category" id=$category->getId()}" alt="{$category->getLocalizedTitle()|escape}" />
						</div>
					{/if}
					<div class="col-md-12">

					</div>

				</div>
			</section>

		{/foreach}
	{/if}

	{capture assign="indexJournalHook"}{call_hook name="Templates::Index::journal"}{/capture}
	{if $indexJournalHook}
		<div class="container">
			{call_hook name="Templates::Index::journal"}
		</div>
	{/if}
{/block}


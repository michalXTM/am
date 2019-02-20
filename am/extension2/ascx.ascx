<%@ Control Language="C#" AutoEventWireup="true" Inherits="Shared.UserControls.BrowserWarning" %>
<asp:Panel runat="server" ID="BrowserWarningPanel" Visible="false">
	<div class="dark module" id="browserWarning">
		<h2>Unsupported browser</h2>
		<div class="section">
		<p>You may experience difficulties using this site. Please read our <a href="/support/#tech1">system requirements</a>.</p>
		<p class="small">You are currently viewing the site with <br />
		<asp:Literal ID="Browser" runat="server" />
		<asp:Literal ID="MajorVersion" runat="server" />.<asp:Literal ID="MinorVersion" runat="server" /></p>
		</div>
	</div>
</asp:Panel>

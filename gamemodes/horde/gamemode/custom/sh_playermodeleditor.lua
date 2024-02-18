function GM:PlayerSetModel(ply)
    return ply:SetModel(ply:GetModel())
end

if SERVER then
    local limit = 2
    local SetMDL = FindMetaTable("Entity").SetModel

    local function player_SetPlayerModel(ply)
        local mdlname = ply:GetInfo( "cl_playermodel" )
        local mdlpath = player_manager.TranslatePlayerModel( mdlname )
        
        SetMDL(ply, mdlpath)

        local skin = ply:GetInfoNum( "cl_playerskin", 0 )
		ply:SetSkin( skin )
		
		local groups = ply:GetInfo( "cl_playerbodygroups" )
		if ( groups == nil ) then groups = "" end
		local groups = string.Explode( " ", groups )
		for k = 0, ply:GetNumBodyGroups() - 1 do
			local v = tonumber( groups[ k + 1 ] ) or 0
			ply:SetBodygroup( k, v )
		end
		
		--[[if GetConVar( "sv_playermodel_selector_flexes" ):GetBool() and tobool( ply:GetInfoNum( "cl_playermodel_selector_unlockflexes", 0 ) ) then
			local flexes = ply:GetInfo( "cl_playerflexes" )
			if ( flexes == nil ) or ( flexes == "0" ) then return end
			local flexes = string.Explode( " ", flexes )
			for k = 0, ply:GetFlexNum() - 1 do
				ply:SetFlexWeight( k, tonumber( flexes[ k + 1 ] ) or 0 )
			end
		end]]
		
		local pcol = ply:GetInfo( "cl_playercolor" )
		local wcol = ply:GetInfo( "cl_weaponcolor" )
		ply:SetPlayerColor( Vector( pcol ) )
		ply:SetWeaponColor( Vector( wcol ) )

        timer.Simple( 0.1, function() if ply.SetupHands and isfunction( ply.SetupHands ) then ply:SetupHands() end end )
		timer.Simple( 0.2, function()
			local mdlhands = player_manager.TranslatePlayerHands( mdlname )
			local hands_ent = ply:GetHands()
			if hands_ent and mdlhands and istable( mdlhands ) then
				if hands_ent:GetModel() != mdlhands.model then
					if ( IsValid( hands_ent ) ) then
						hands_ent:SetModel( mdlhands.model )
						hands_ent:SetSkin( mdlhands.skin )
						hands_ent:SetBodyGroups( mdlhands.body )
					end
				end
			end
		end )
		
		if addon_legs then
			hook.Run( "SetModel", ply, mdlpath )
		end
    end

    util.AddNetworkString("HordePlayerModelSelector_SetModel")
    net.Receive("HordePlayerModelSelector_SetModel", function(len, ply)
        local ct = CurTime()
        local diff1 = ct - ( ply.playermodel_lastcall or limit*(-1) )
        local diff2 = ct - ( ply.playermodel_lastsuccess or limit*(-1) )
        if diff1 < 0.2 then
            ply:Kick( "Too many requests. Please check your script for infinite loops" )
        elseif diff2 >= limit then
            ply.playermodel_lastcall = ct
            ply.playermodel_lastsuccess = ct
            player_SetPlayerModel(ply)
        else
            ply.playermodel_lastcall = ct
            ply:ChatPrint( "Enhanced PlayerModel Selector: Too many requests. Please wait another "..tostring( limit - math.floor( diff2 ) ).." seconds before trying again." )
        end
    end)
    return
end

local PANEL = {}

local default_animations = { "idle_all_01", "menu_walk" }

function PANEL:Init()
    self:SetSize(960, 700)

    self:SetTitle( "#smwidget.playermodel_title" )
    self:SetSize( math.min( ScrW() - 16, self:GetWide() ), math.min( ScrH() - 16, self:GetTall() ) )
    self:SetSizable( true )
    self:SetMinWidth( self:GetWide() )
    self:SetMinHeight( self:GetTall() )
    self:SetDraggable( true )
	self:SetScreenLock( false )
	self:ShowCloseButton( true )
	self:Center()
	self:MakePopup()
	self:SetKeyboardInputEnabled( false )

    local mdl = self:Add( "DModelPanel" )
    mdl:Dock( FILL )
    mdl:SetFOV( 36 )
    mdl:SetCamPos( vector_origin )
    mdl:SetDirectionalLight( BOX_RIGHT, Color( 255, 160, 80, 255 ) )
    mdl:SetDirectionalLight( BOX_LEFT, Color( 80, 160, 255, 255 ) )
    mdl:SetAmbientLight( Vector( -64, -64, -64 ) )
    mdl:SetAnimated( true )
    mdl.Angles = angle_zero
    mdl:SetLookAt( Vector( -100, 0, -22 ) )

    local sheet = self:Add( "DPropertySheet" )
    sheet:Dock( RIGHT )
    sheet:SetSize( 430, 0 )

    local modelListPnl = self:Add( "DPanel" )
    modelListPnl:DockPadding( 8, 8, 8, 8 )

    local SearchBar = modelListPnl:Add( "DTextEntry" )
    SearchBar:Dock( TOP )
    SearchBar:DockMargin( 0, 0, 0, 8 )
    SearchBar:SetUpdateOnType( true )
    SearchBar:SetPlaceholderText( "#spawnmenu.quick_filter" )

    local PanelSelect = modelListPnl:Add( "DPanelSelect" )
    PanelSelect:Dock( FILL )

    for name, model in SortedPairs( player_manager.AllValidModels() ) do

        local icon = vgui.Create( "SpawnIcon" )
        icon:SetModel( model )
        icon:SetSize( 64, 64 )
        icon:SetTooltip( name )
        icon.playermodel = name
        icon.model_path = model
        icon.OpenMenu = function( button )
            local menu = DermaMenu()
            menu:AddOption( "#spawnmenu.menu.copy", function() SetClipboardText( model ) end ):SetIcon( "icon16/page_copy.png" )
            menu:Open()
        end

        PanelSelect:AddPanel( icon, { cl_playermodel = name } )

    end

    SearchBar.OnValueChange = function( s, str )
        for id, pnl in pairs( PanelSelect:GetItems() ) do
            if ( !pnl.playermodel:find( str, 1, true ) && !pnl.model_path:find( str, 1, true ) ) then
                pnl:SetVisible( false )
            else
                pnl:SetVisible( true )
            end
        end
        PanelSelect:InvalidateLayout()
    end

    sheet:AddSheet( "#smwidget.model", modelListPnl, "icon16/user.png" )

    local controls = self:Add( "DPanel" )
    controls:DockPadding( 8, 8, 8, 8 )

    local lbl = controls:Add( "DLabel" )
    lbl:SetText( "#smwidget.color_plr" )
    lbl:SetTextColor( Color( 0, 0, 0, 255 ) )
    lbl:Dock( TOP )

    local plycol = controls:Add( "DColorMixer" )
    plycol:SetAlphaBar( false )
    plycol:SetPalette( false )
    plycol:Dock( TOP )
    plycol:SetSize( 200, math.min( self:GetTall() / 3, 260 ) )

    local lbl = controls:Add( "DLabel" )
    lbl:SetText( "#smwidget.color_wep" )
    lbl:SetTextColor( Color( 0, 0, 0, 255 ) )
    lbl:DockMargin( 0, 32, 0, 0 )
    lbl:Dock( TOP )

    local wepcol = controls:Add( "DColorMixer" )
    wepcol:SetAlphaBar( false )
    wepcol:SetPalette( false )
    wepcol:Dock( TOP )
    wepcol:SetSize( 200, math.min( self:GetTall() / 3, 260 ) )
    wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) );

    sheet:AddSheet( "#smwidget.colors", controls, "icon16/color_wheel.png" )

    local bdcontrols = self:Add( "DPanel" )
    bdcontrols:DockPadding( 8, 8, 8, 8 )

    local bdcontrolspanel = bdcontrols:Add( "DPanelList" )
    bdcontrolspanel:EnableVerticalScrollbar( true )
    bdcontrolspanel:Dock( FILL )

    local bgtab = sheet:AddSheet( "#smwidget.bodygroups", bdcontrols, "icon16/cog.png" )

    -- Helper functions

    local function MakeNiceName( str )
        local nicename = {}

        for i, word in ipairs( string.Explode( "_", str ) ) do
            if ( #word == 1 ) then
                nicename[i] = string.upper( string.sub( word, 1, 1 ) )
                continue
            end
            
            nicename[i] = string.upper( string.sub( word, 1, 1 ) ) .. string.sub( word, 2 )
        end

        return table.concat( nicename, " " )
    end

    local function PlayPreviewAnimation( panel, playermodel )

        if ( !panel or !IsValid( panel.Entity ) ) then return end

        local anims = list.Get( "PlayerOptionsAnimations" )

        local anim = default_animations[ math.random( 1, #default_animations ) ]
        if ( anims[ playermodel ] ) then
            anims = anims[ playermodel ]
            anim = anims[ math.random( 1, #anims ) ]
        end

        local iSeq = panel.Entity:LookupSequence( anim )
        if ( iSeq > 0 ) then panel.Entity:ResetSequence( iSeq ) end

    end

    -- Updating
    local function UpdateBodyGroups( pnl, val )
        if ( pnl.type == "bgroup" ) then

            mdl.Entity:SetBodygroup( pnl.typenum, math.Round( val ) )

            local str = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
            if ( #str < pnl.typenum + 1 ) then for i = 1, pnl.typenum + 1 do str[ i ] = str[ i ] or 0 end end
            str[ pnl.typenum + 1 ] = math.Round( val )
            RunConsoleCommand( "cl_playerbodygroups", table.concat( str, " " ) )

        elseif ( pnl.type == "skin" ) then

            mdl.Entity:SetSkin( math.Round( val ) )
            RunConsoleCommand( "cl_playerskin", math.Round( val ) )

        end
    end

    local function RebuildBodygroupTab()
        bdcontrolspanel:Clear()

        bgtab.Tab:SetVisible( false )

        local nskins = mdl.Entity:SkinCount() - 1
        if ( nskins > 0 ) then
            local skins = vgui.Create( "DNumSlider" )
            skins:Dock( TOP )
            skins:SetText( "Skin" )
            skins:SetDark( true )
            skins:SetTall( 50 )
            skins:SetDecimals( 0 )
            skins:SetMax( nskins )
            skins:SetValue( GetConVarNumber( "cl_playerskin" ) )
            skins.type = "skin"
            skins.OnValueChanged = UpdateBodyGroups

            bdcontrolspanel:AddItem( skins )

            mdl.Entity:SetSkin( GetConVarNumber( "cl_playerskin" ) )

            bgtab.Tab:SetVisible( true )
        end

        local groups = string.Explode( " ", GetConVarString( "cl_playerbodygroups" ) )
        for k = 0, mdl.Entity:GetNumBodyGroups() - 1 do
            if ( mdl.Entity:GetBodygroupCount( k ) <= 1 ) then continue end

            local bgroup = vgui.Create( "DNumSlider" )
            bgroup:Dock( TOP )
            bgroup:SetText( MakeNiceName( mdl.Entity:GetBodygroupName( k ) ) )
            bgroup:SetDark( true )
            bgroup:SetTall( 50 )
            bgroup:SetDecimals( 0 )
            bgroup.type = "bgroup"
            bgroup.typenum = k
            bgroup:SetMax( mdl.Entity:GetBodygroupCount( k ) - 1 )
            bgroup:SetValue( groups[ k + 1 ] or 0 )
            bgroup.OnValueChanged = UpdateBodyGroups

            bdcontrolspanel:AddItem( bgroup )

            mdl.Entity:SetBodygroup( k, groups[ k + 1 ] or 0 )

            bgtab.Tab:SetVisible( true )
        end

        sheet.tabScroller:InvalidateLayout()
    end

    local function UpdateFromConvars()

        local model = LocalPlayer():GetInfo( "cl_playermodel" )
        local modelname = player_manager.TranslatePlayerModel( model )
        util.PrecacheModel( modelname )
        mdl:SetModel( modelname )
        mdl.Entity.GetPlayerColor = function() return Vector( GetConVarString( "cl_playercolor" ) ) end
        mdl.Entity:SetPos( Vector( -100, 0, -61 ) )

        plycol:SetVector( Vector( GetConVarString( "cl_playercolor" ) ) )
        wepcol:SetVector( Vector( GetConVarString( "cl_weaponcolor" ) ) )

        PlayPreviewAnimation( mdl, model )
        RebuildBodygroupTab()

    end

    local function UpdateFromControls()

        RunConsoleCommand( "cl_playercolor", tostring( plycol:GetVector() ) )
        RunConsoleCommand( "cl_weaponcolor", tostring( wepcol:GetVector() ) )

    end

    plycol.ValueChanged = UpdateFromControls
    wepcol.ValueChanged = UpdateFromControls

    UpdateFromConvars()

    function PanelSelect:OnActivePanelChanged( old, new )

        if ( old != new ) then -- Only reset if we changed the model
            RunConsoleCommand( "cl_playerbodygroups", "0" )
            RunConsoleCommand( "cl_playerskin", "0" )
        end

        timer.Simple( 0.1, function() UpdateFromConvars() end )

    end

    -- Hold to rotate

    function mdl:DragMousePress()
        self.PressX, self.PressY = gui.MousePos()
        self.Pressed = true
    end

    function mdl:DragMouseRelease() self.Pressed = false end

    function mdl:LayoutEntity( ent )
        if ( self.bAnimated ) then self:RunAnimation() end

        if ( self.Pressed ) then
            local mx = gui.MousePos()
            self.Angles = self.Angles - Angle( 0, ( ( self.PressX or mx ) - mx ) / 2, 0 )

            self.PressX, self.PressY = gui.MousePos()
        end

        ent:SetAngles( self.Angles )
    end
end

function PANEL:OnClose()
    net.Start("HordePlayerModelSelector_SetModel")
    net.SendToServer()
end

vgui.Register("HordePlayerModelSelector", PANEL, "DFrame")
# Copyright 2015 SpinalCom  www.spinalcom.com
#
# This file is part of SpinalCore.
#
# SpinalCore is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Soda is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# You should have received a copy of the GNU General Public License
# along with Soda. If not, see <http://www.gnu.org/licenses/>.



#
class TreeAppModule_PanelManager extends TreeAppModule
    constructor: ->
        super()
        
        @name = ' '

        _ina = ( app ) =>
            app.data.focus.get() != app.selected_canvas_inst()?[ 0 ]?.cm?.process_id

            
         @actions.push
            vis: false
            ico: "img/scientific_framework.png"
            siz: 0.9
            txt: "Scientific framework"
            fun: ( evt, app ) => 
                app.data.display_scientific_framework()
                d = app.data.selected_display_settings()
                app.data.update_associated_layout_data d
                alert "ok scientific"
            #key: [ "Shift+V" ]
             
        @actions.push
            vis: false
            ico: "img/vertical_split_grey.png"
            siz: 0.9
            txt: "Standard framework"
            fun: ( evt, app ) ->
                app.data.display_scientific_framework()
                d = app.data.selected_display_settings()
                app.data.update_associated_layout_data d
                alert "ok standard"
            #key: [ "F" ]    
            
        @actions.push
            vis: false
            ico: "img/vertical_split_grey.png"
            siz: 1
            txt: "Vertical Split"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 0
            key: [ "Shift+V" ]
             
        @actions.push
            vis: false
            ico: "img/fit.png"
            siz: 1
            txt: "Fit object to the view"
            ina: _ina
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.fit()
            key: [ "F" ]
            
        @actions.push
            vis: false
            ico: "img/horizontal_split.png"
            siz: 1
            txt: "Horizontal Split"
            ina: _ina
            fun: ( evt, app ) => @split_view evt, app, 1
            key: [ "Shift+H" ]
            
            
        cube =
            vis: false
            ico: "img/cube.png"
            siz: 1
            txt: "View"
            ina: _ina
            sub:
                prf: "list"
                act: [ ]
            key: [ "V" ]
        @actions.push cube
        
        cube.sub.act.push 
            vis: false
            ico: "img/origin.png"
            txt: "Origin Camera"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.origin()
            key: [ "O" ]
            
        cube.sub.act.push 
            vis: false
            ico: "img/top.png"
            txt: "Watch top"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.top()
            key: [ "T" ]
            
        cube.sub.act.push 
            txt: "Watch bottom"
            ina: _ina
            vis: false
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.bottom()
            key: [ "B" ]
            
        cube.sub.act.push 
            vis: false
            ico: "img/right.png"
            txt: "Watch right"
            ina: _ina
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.right()
            key: [ "R" ]
            
        cube.sub.act.push 
            txt: "Watch left"
            ina: _ina
            vis: false
            siz: 1
            fun: ( evt, app ) ->
                for inst in app.selected_canvas_inst()
                    inst.cm.left()
            key: [ "L" ]
            
            
        @actions.push
            vis: false
            ico: "img/close_panel.png"
            siz: 1
            txt: "Close current view"
            ina: _ina
            fun: ( evt, app ) ->
                app.undo_manager.snapshot()
                app.data.rm_selected_panels()
            key: [ "Shift+X" ]
        
        @actions.push
            vis: false
            ico: "img/zoom_32.png"
            siz: 1
            txt: "Zoom"
            ina: _ina
#             vis: false
            fun: ( evt, app ) ->
                if not @zoom_area
                    @old_cm = app.selected_canvas_inst()?[ 0 ]?.cm
                    @theme = @old_cm.theme
                    @zoom_area = new ZoomArea @old_cm, zoom_factor : [ @theme.zoom_factor, @theme.zoom_factor, 1 ]
                    @zoom_area.zoom_pos.set [ @old_cm.mouse_x, @old_cm.mouse_y ]
                    @old_cm.items.push @zoom_area
                else
                    @old_cm.items.remove_ref @zoom_area
                    @old_cm.draw()
                    @theme.zoom_factor.set @zoom_area.zoom_factor[ 0 ] # use last zoom_factor as a default for user
                    delete @zoom_area
                    
            key: [ "Z" ]
                
        @actions.push
            vis: false
            txt: ""
            key: [ "UpArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate -0.1, 0, 0

        @actions.push
            vis: false
            txt: ""
            key: [ "DownArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0.1, 0, 0

        @actions.push
            vis: false
            txt: ""
            key: [ "LeftArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0, -0.1, 0
                            
        @actions.push
            vis: false
            txt: ""
            key: [ "RightArrow" ]
            ina: _ina
            fun: ( evt, app ) =>
                for inst in app.selected_canvas_inst()
                    inst.cm.cam.rotate 0, 0.1, 0
    

    split_view: ( evt, app, n ) ->
        app.undo_manager.snapshot()
        cam = undefined
        child = undefined
        for p in app.data.selected_tree_items
            s = p[ p.length - 1 ]
            if s instanceof ShootingItem
                cam = s.cam
                child = s
#         console.log cam
                
        d = app.data.selected_display_settings()
        for panel_id in app.data.selected_canvas_pan
            app._next_view_item_cam = cam
            app._next_view_item_child = child
            d._layout.mk_split n, 0, panel_id, 0.5
        
        
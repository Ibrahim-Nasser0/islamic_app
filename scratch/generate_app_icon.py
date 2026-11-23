import os
import math
from PIL import Image, ImageDraw, ImageFilter

def create_app_icon():
    # Render at 2048x2048 for supersampled anti-aliased perfection
    size = 2048
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))

    cx, cy = size / 2, size / 2

    # 1. Background: Deep Royal Emerald Gradient
    base_bg = Image.new("RGBA", (size, size), (12, 29, 24, 255)) # #0C1D18
    bg_draw = ImageDraw.Draw(base_bg)
    
    steps = 100
    for i in range(steps, 0, -1):
        r = (i / steps) * (size * 0.75)
        factor = i / steps
        # Lerp from center #1B5E4F (27, 94, 79) to #0C1D18 (12, 29, 24)
        red = int(27 * factor + 12 * (1 - factor))
        green = int(94 * factor + 29 * (1 - factor))
        blue = int(79 * factor + 24 * (1 - factor))
        bg_draw.ellipse(
            [cx - r, cy - r, cx + r, cy + r],
            fill=(red, green, blue, 255)
        )

    base_bg = base_bg.filter(ImageFilter.GaussianBlur(radius=30))
    img.paste(base_bg, (0, 0))

    # 2. Subtle Sacred Islamic 8-Point Star Pattern in background
    pattern_layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    pat_draw = ImageDraw.Draw(pattern_layer)
    star_radius = size * 0.44
    gold_faint = (216, 180, 103, 18) # 7% gold
    
    for angle_deg in [0, 45]:
        angle = math.radians(angle_deg)
        pts = []
        for a_deg in range(0, 360, 90):
            rad = math.radians(a_deg + angle_deg)
            x = cx + star_radius * math.cos(rad)
            y = cy + star_radius * math.sin(rad)
            pts.append((x, y))
        pat_draw.polygon(pts, outline=gold_faint, width=8)

    inner_star_radius = size * 0.41
    for angle_deg in [22.5, 67.5]:
        angle = math.radians(angle_deg)
        pts = []
        for a_deg in range(0, 360, 90):
            rad = math.radians(a_deg + angle_deg)
            x = cx + inner_star_radius * math.cos(rad)
            y = cy + inner_star_radius * math.sin(rad)
            pts.append((x, y))
        pat_draw.polygon(pts, outline=(216, 180, 103, 12), width=6)

    img.alpha_composite(pattern_layer)

    # 3. Central Medallion Circle (The exact container from the App Bar)
    medallion_layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    m_draw = ImageDraw.Draw(medallion_layer)

    med_radius = size * 0.38
    # Outer gold halo / glow
    halo = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    h_draw = ImageDraw.Draw(halo)
    h_draw.ellipse(
        [cx - med_radius - 20, cy - med_radius - 20, cx + med_radius + 20, cy + med_radius + 20],
        outline=(216, 180, 103, 80),
        width=30
    )
    halo = halo.filter(ImageFilter.GaussianBlur(radius=20))
    img.alpha_composite(halo)

    # Inner circular disc: Deep Emerald Glass
    m_draw.ellipse(
        [cx - med_radius, cy - med_radius, cx + med_radius, cy + med_radius],
        fill=(17, 53, 45, 235), # #11352D
        outline=(216, 180, 103, 240), # Solid gold rim
        width=18
    )

    # Secondary hairline inner gold ring
    inner_rim_radius = med_radius - 32
    m_draw.ellipse(
        [cx - inner_rim_radius, cy - inner_rim_radius, cx + inner_rim_radius, cy + inner_rim_radius],
        outline=(216, 180, 103, 90),
        width=6
    )

    img.alpha_composite(medallion_layer)

    # 4. The Sacred Mosque Silhouette (exact Icons.mosque_rounded representation)
    mosque_layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    mosque_draw = ImageDraw.Draw(mosque_layer)

    gold_primary = (228, 196, 122, 255) # Radiant Gold
    gold_highlight = (248, 230, 178, 255)
    gold_shadow = (175, 138, 62, 255)

    base_y = cy + size * 0.22
    mosque_width = size * 0.48
    half_w = mosque_width / 2

    # A. Minarets (Left and Right)
    minaret_w = size * 0.048
    minaret_h = size * 0.32
    m_left_x = cx - half_w + minaret_w / 2
    m_right_x = cx + half_w - minaret_w / 2

    for min_x in [m_left_x, m_right_x]:
        shaft_left = min_x - minaret_w / 2
        shaft_right = min_x + minaret_w / 2
        shaft_top = base_y - minaret_h
        mosque_draw.rounded_rectangle(
            [shaft_left, shaft_top, shaft_right, base_y],
            radius=minaret_w * 0.3,
            fill=gold_primary
        )

        b1_y = shaft_top + minaret_h * 0.45
        b_w = minaret_w * 1.5
        mosque_draw.rounded_rectangle(
            [min_x - b_w / 2, b1_y - 12, min_x + b_w / 2, b1_y + 12],
            radius=8,
            fill=gold_highlight
        )

        b2_y = shaft_top + 16
        mosque_draw.rounded_rectangle(
            [min_x - b_w / 2, b2_y - 12, min_x + b_w / 2, b2_y + 12],
            radius=8,
            fill=gold_highlight
        )

        cap_top = shaft_top - size * 0.065
        cap_pts = [
            (min_x, cap_top),
            (min_x - minaret_w * 0.7, shaft_top + 5),
            (min_x + minaret_w * 0.7, shaft_top + 5),
        ]
        mosque_draw.polygon(cap_pts, fill=gold_highlight)

        spire_top = cap_top - size * 0.025
        mosque_draw.line([(min_x, cap_top), (min_x, spire_top)], fill=gold_highlight, width=8)
        c_r = 14
        mosque_draw.ellipse([min_x - c_r, spire_top - c_r * 2, min_x + c_r, spire_top], fill=gold_highlight)
        mosque_draw.ellipse([min_x - c_r * 0.4, spire_top - c_r * 1.8, min_x + c_r * 1.3, spire_top - c_r * 0.2], fill=(17, 53, 45, 255))

    # B. Central Building Main Body
    body_left = m_left_x + minaret_w * 0.7
    body_right = m_right_x - minaret_w * 0.7
    body_h = size * 0.16
    body_top = base_y - body_h

    mosque_draw.rounded_rectangle(
        [body_left, body_top, body_right, base_y],
        radius=20,
        fill=gold_primary
    )

    mosque_draw.rounded_rectangle(
        [m_left_x - minaret_w * 0.5, base_y - 16, m_right_x + minaret_w * 0.5, base_y + 18],
        radius=10,
        fill=gold_shadow
    )

    # C. Central Grand Dome
    dome_w = (body_right - body_left) * 0.74
    dome_h = size * 0.23
    dome_bottom = body_top + 8
    dome_cx = cx

    dome_pts = []
    dome_steps = 60
    for s in range(dome_steps + 1):
        t = s / dome_steps
        angle = math.pi * t
        width_mod = math.sin(angle) * (1.0 + 0.18 * math.sin(angle))
        dx = (dome_w / 2) * math.cos(angle)
        dy = -dome_h * math.sin(angle)
        dome_pts.append((dome_cx - dx, dome_bottom + dy))

    dome_pts.append((dome_cx + dome_w / 2, dome_bottom))
    dome_pts.append((dome_cx - dome_w / 2, dome_bottom))
    mosque_draw.polygon(dome_pts, fill=gold_primary)

    dome_apex_y = dome_bottom - dome_h
    spire_h = size * 0.045
    mosque_draw.line([(cx, dome_apex_y + 10), (cx, dome_apex_y - spire_h)], fill=gold_highlight, width=10)
    cr_r = 24
    cr_y = dome_apex_y - spire_h
    mosque_draw.ellipse([cx - cr_r, cr_y - cr_r * 2, cx + cr_r, cr_y], fill=gold_highlight)
    mosque_draw.ellipse([cx - cr_r * 0.3, cr_y - cr_r * 1.8, cx + cr_r * 1.4, cr_y - cr_r * 0.2], fill=(17, 53, 45, 255))

    # D. Arched Portal Entrance
    door_w = size * 0.088
    door_h = size * 0.115
    door_left = cx - door_w / 2
    door_right = cx + door_w / 2
    door_bottom = base_y
    door_top = base_y - door_h

    door_pts = []
    for s in range(31):
        a = math.pi * (s / 30)
        px = cx + (door_w / 2) * math.cos(a)
        py = door_top + (door_w / 2) - (door_w / 2) * math.sin(a)
        door_pts.append((px, py))
    door_pts.append((door_left, door_bottom))
    door_pts.append((door_right, door_bottom))

    mosque_draw.polygon(door_pts, fill=(17, 53, 45, 255))
    mosque_draw.polygon(door_pts, outline=gold_highlight, width=5)

    # E. Symmetrical Arched Windows
    win_w = size * 0.038
    win_h = size * 0.062
    win_bottom = base_y - size * 0.025
    win_top = win_bottom - win_h

    for win_cx in [cx - size * 0.09, cx + size * 0.09]:
        w_pts = []
        for s in range(21):
            a = math.pi * (s / 20)
            px = win_cx + (win_w / 2) * math.cos(a)
            py = win_top + (win_w / 2) - (win_w / 2) * math.sin(a)
            w_pts.append((px, py))
        w_pts.append((win_cx - win_w / 2, win_bottom))
        w_pts.append((win_cx + win_w / 2, win_bottom))
        mosque_draw.polygon(w_pts, fill=(17, 53, 45, 255))
        mosque_draw.polygon(w_pts, outline=gold_highlight, width=4)

    # F. Dome Arch Windows
    dwin_w = size * 0.024
    dwin_h = size * 0.038
    dwin_bottom = body_top - 6
    dwin_top = dwin_bottom - dwin_h

    for dwin_cx in [cx - size * 0.05, cx, cx + size * 0.05]:
        dw_pts = []
        for s in range(17):
            a = math.pi * (s / 16)
            px = dwin_cx + (dwin_w / 2) * math.cos(a)
            py = dwin_top + (dwin_w / 2) - (dwin_w / 2) * math.sin(a)
            dw_pts.append((px, py))
        dw_pts.append((dwin_cx - dwin_w / 2, dwin_bottom))
        dw_pts.append((dwin_cx + dwin_w / 2, dwin_bottom))
        mosque_draw.polygon(dw_pts, fill=(17, 53, 45, 255))
        mosque_draw.polygon(dw_pts, outline=gold_highlight, width=3)

    img.alpha_composite(mosque_layer)

    # 5. Downsample to 1024x1024 with Lanczos
    master_1024 = img.resize((1024, 1024), Image.Resampling.LANCZOS)
    return master_1024

def save_all_icons(master):
    # 1. Assets
    os.makedirs('assets/images', exist_ok=True)
    os.makedirs('assets/icons', exist_ok=True)
    master.save('assets/images/app_logo.png', format='PNG', optimize=True)
    master.resize((512, 512), Image.Resampling.LANCZOS).save('assets/icons/app_icon.png', format='PNG', optimize=True)
    print('[+] Saved assets/images/app_logo.png & assets/icons/app_icon.png')

    # 2. Android Mipmaps
    android_res = 'android/app/src/main/res'
    android_sizes = {
        'mipmap-mdpi': (48, 48),
        'mipmap-hdpi': (72, 72),
        'mipmap-xhdpi': (96, 96),
        'mipmap-xxhdpi': (144, 144),
        'mipmap-xxxhdpi': (192, 192),
    }
    for folder, dim in android_sizes.items():
        dir_path = os.path.join(android_res, folder)
        os.makedirs(dir_path, exist_ok=True)
        out_path = os.path.join(dir_path, 'ic_launcher.png')
        master.resize(dim, Image.Resampling.LANCZOS).save(out_path, format='PNG', optimize=True)
        print(f'[+] Saved Android {folder}/ic_launcher.png {dim}')

    # 3. iOS AppIcon.appiconset
    ios_dir = 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    if os.path.exists(ios_dir):
        ios_icons = {
            'Icon-App-20x20@1x.png': (20, 20),
            'Icon-App-20x20@2x.png': (40, 40),
            'Icon-App-20x20@3x.png': (60, 60),
            'Icon-App-29x29@1x.png': (29, 29),
            'Icon-App-29x29@2x.png': (58, 58),
            'Icon-App-29x29@3x.png': (87, 87),
            'Icon-App-40x40@1x.png': (40, 40),
            'Icon-App-40x40@2x.png': (80, 80),
            'Icon-App-40x40@3x.png': (120, 120),
            'Icon-App-60x60@2x.png': (120, 120),
            'Icon-App-60x60@3x.png': (180, 180),
            'Icon-App-76x76@1x.png': (76, 76),
            'Icon-App-76x76@2x.png': (152, 152),
            'Icon-App-83.5x83.5@2x.png': (167, 167),
            'Icon-App-1024x1024@1x.png': (1024, 1024),
        }
        for name, dim in ios_icons.items():
            out_path = os.path.join(ios_dir, name)
            master.resize(dim, Image.Resampling.LANCZOS).save(out_path, format='PNG', optimize=True)
            print(f'[+] Saved iOS {name} {dim}')

    # 4. Web icons
    web_dir = 'web'
    if os.path.exists(web_dir):
        master.resize((32, 32), Image.Resampling.LANCZOS).save(os.path.join(web_dir, 'favicon.png'), format='PNG', optimize=True)
        web_icons_dir = os.path.join(web_dir, 'icons')
        os.makedirs(web_icons_dir, exist_ok=True)
        master.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, 'Icon-192.png'), format='PNG', optimize=True)
        master.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, 'Icon-512.png'), format='PNG', optimize=True)
        master.resize((192, 192), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, 'Icon-maskable-192.png'), format='PNG', optimize=True)
        master.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(web_icons_dir, 'Icon-maskable-512.png'), format='PNG', optimize=True)
        print('[+] Saved Web icons')

if __name__ == '__main__':
    print('Generating Zad Al-Muslim App Icons...')
    master = create_app_icon()
    save_all_icons(master)
    print('All app icons successfully generated!')

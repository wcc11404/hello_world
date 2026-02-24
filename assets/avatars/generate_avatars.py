from PIL import Image, ImageDraw
import os
import math

def draw_taiji_avatar(size, colors, draw_style="taiji"):
    """绘制太极风格头像"""
    width, height = size
    img = Image.new('RGBA', size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    center_x = width // 2
    center_y = height // 2
    radius = width // 2 - 4
    
    bg_color, dark_color, light_color, accent_color = colors
    
    # 绘制外圈背景
    draw.ellipse([center_x - radius - 2, center_y - radius - 2, 
                  center_x + radius + 2, center_y + radius + 2], fill=bg_color)
    
    if draw_style == "taiji":
        # 绘制太极图案
        # 左半部分（深色）
        draw.pieslice([center_x - radius, center_y - radius, 
                       center_x + radius, center_y + radius], 
                      start=90, end=270, fill=dark_color)
        
        # 右半部分（浅色）
        draw.pieslice([center_x - radius, center_y - radius, 
                       center_x + radius, center_y + radius], 
                      start=270, end=90, fill=light_color)
        
        # 上半部分小圆（深色）
        small_radius = radius // 2
        draw.ellipse([center_x - small_radius, center_y - radius, 
                      center_x + small_radius, center_y], fill=dark_color)
        
        # 下半部分小圆（浅色）
        draw.ellipse([center_x - small_radius, center_y, 
                      center_x + small_radius, center_y + radius], fill=light_color)
        
        # 上半部分小圆点（浅色）
        dot_radius = radius // 6
        draw.ellipse([center_x - dot_radius, center_y - radius // 2 - dot_radius, 
                      center_x + dot_radius, center_y - radius // 2 + dot_radius], fill=light_color)
        
        # 下半部分小圆点（深色）
        draw.ellipse([center_x - dot_radius, center_y + radius // 2 - dot_radius, 
                      center_x + dot_radius, center_y + radius // 2 + dot_radius], fill=dark_color)
    
    elif draw_style == "circle":
        # 同心圆风格
        draw.ellipse([center_x - radius, center_y - radius, 
                      center_x + radius, center_y + radius], fill=dark_color)
        
        mid_radius = radius * 2 // 3
        draw.ellipse([center_x - mid_radius, center_y - mid_radius, 
                      center_x + mid_radius, center_y + mid_radius], fill=light_color)
        
        inner_radius = radius // 3
        draw.ellipse([center_x - inner_radius, center_y - inner_radius, 
                      center_x + inner_radius, center_y + inner_radius], fill=accent_color)
    
    # 绘制外圈边框
    draw.ellipse([center_x - radius, center_y - radius, 
                  center_x + radius, center_y + radius], 
                 outline=accent_color, width=2)
    
    return img

def generate_qi_refining_avatar(size=(64, 64)):
    """炼气期头像 - 黑白太极"""
    colors = (
        (40, 40, 40, 255),     # 背景
        (20, 20, 20, 255),     # 深色（黑）
        (200, 200, 200, 255),  # 浅色（白）
        (100, 100, 100, 255)   # 边框
    )
    return draw_taiji_avatar(size, colors, "taiji")

def generate_foundation_avatar(size=(64, 64)):
    """筑基期头像 - 棕黄太极"""
    colors = (
        (120, 100, 60, 255),   # 背景
        (100, 80, 50, 255),    # 深色（棕）
        (220, 200, 150, 255),  # 浅色（黄）
        (160, 140, 100, 255)   # 边框
    )
    return draw_taiji_avatar(size, colors, "taiji")

def generate_golden_core_avatar(size=(64, 64)):
    """金丹期头像 - 红黄太极"""
    colors = (
        (180, 60, 50, 255),    # 背景
        (160, 50, 40, 255),    # 深色（红）
        (250, 200, 100, 255),  # 浅色（金）
        (200, 120, 60, 255)    # 边框
    )
    return draw_taiji_avatar(size, colors, "taiji")

def generate_nascent_soul_avatar(size=(64, 64)):
    """元婴期头像 - 紫粉太极"""
    colors = (
        (120, 80, 150, 255),   # 背景
        (100, 60, 130, 255),   # 深色（紫）
        (200, 150, 200, 255),  # 浅色（粉）
        (160, 100, 180, 255)   # 边框
    )
    return draw_taiji_avatar(size, colors, "taiji")

def generate_abstract_avatar(size=(64, 64)):
    """抽象头像 - 蓝紫同心圆"""
    colors = (
        (80, 100, 150, 255),   # 背景
        (60, 80, 130, 255),    # 深色
        (150, 170, 220, 255),  # 浅色
        (200, 200, 230, 255)   # 中心
    )
    return draw_taiji_avatar(size, colors, "circle")

def main():
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    output_dir = os.path.join(project_root, 'assets', 'avatars')
    os.makedirs(output_dir, exist_ok=True)
    
    avatar_size = (64, 64)
    
    # 生成炼气期头像
    qi_refining = generate_qi_refining_avatar(avatar_size)
    qi_refining.save(os.path.join(output_dir, 'avatar_qi_refining.png'))
    print(f'生成炼气期头像: avatar_qi_refining.png')
    
    # 生成筑基期头像
    foundation = generate_foundation_avatar(avatar_size)
    foundation.save(os.path.join(output_dir, 'avatar_foundation.png'))
    print(f'生成筑基期头像: avatar_foundation.png')
    
    # 生成金丹期头像
    golden_core = generate_golden_core_avatar(avatar_size)
    golden_core.save(os.path.join(output_dir, 'avatar_golden_core.png'))
    print(f'生成金丹期头像: avatar_golden_core.png')
    
    # 生成元婴期头像
    nascent_soul = generate_nascent_soul_avatar(avatar_size)
    nascent_soul.save(os.path.join(output_dir, 'avatar_nascent_soul.png'))
    print(f'生成元婴期头像: avatar_nascent_soul.png')
    
    # 生成抽象头像
    abstract = generate_abstract_avatar(avatar_size)
    abstract.save(os.path.join(output_dir, 'avatar_abstract.png'))
    print(f'生成抽象头像: avatar_abstract.png')

if __name__ == '__main__':
    main()

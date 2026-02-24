from PIL import Image, ImageDraw, ImageFilter
import math
import os
import random

def draw_ink_blot(draw, x, y, size, opacity=150):
    """绘制水墨晕染效果"""
    for i in range(5):
        r = size * (1 + i * 0.3)
        color = (60, 60, 60, opacity - i * 25)
        draw.ellipse([x - r, y - r, x + r, y + r], fill=color)

def create_cultivation_figure_base(size=(200, 200)):
    """创建水墨风格的修炼小人基础版本（带镂空气海，占满画布）"""
    # 1. 创建一个临时画布，先绘制完整的小人
    temp_img = Image.new('RGBA', size, (0, 0, 0, 0))
    temp_draw = ImageDraw.Draw(temp_img)
    
    center_x = size[0] // 2
    center_y = size[1] // 2 + 10
    
    # 2. 绘制盘腿坐姿的身体（先不画气海）
    # 头部（更大）- 颜色与身体一致
    head_radius = 28
    for i in range(3):
        r = head_radius + i * 3
        alpha = 180 - i * 40
        temp_draw.ellipse([center_x - r, center_y - 60 - r, center_x + r, center_y - 60 + r], 
                      fill=(50, 50, 50, alpha))
    temp_draw.ellipse([center_x - head_radius, center_y - 60 - head_radius, 
                  center_x + head_radius, center_y - 60 + head_radius], 
                 fill=(35, 35, 35, 210))
    
    # 修仙风格的脸部 - 只保留坚毅的眼睛
    eye_y = center_y - 60
    
    # 眼睛 - 更坚毅的修仙风格眼睛
    # 左眼 - 更锐利的形状
    temp_draw.polygon([
        (center_x - 15, eye_y - 1),
        (center_x - 9, eye_y - 3),
        (center_x - 7, eye_y),
        (center_x - 9, eye_y + 2),
        (center_x - 15, eye_y + 1)
    ], fill=(8, 8, 8, 255))
    # 右眼
    temp_draw.polygon([
        (center_x + 15, eye_y - 1),
        (center_x + 9, eye_y - 3),
        (center_x + 7, eye_y),
        (center_x + 9, eye_y + 2),
        (center_x + 15, eye_y + 1)
    ], fill=(8, 8, 8, 255))
    
    # 眼睛高光 - 更有神
    temp_draw.ellipse([center_x - 12, eye_y - 1, center_x - 10, eye_y + 1], fill=(100, 100, 100, 240))
    temp_draw.ellipse([center_x + 10, eye_y - 1, center_x + 12, eye_y + 1], fill=(100, 100, 100, 240))
    
    # 上眼睑线条 - 更坚毅
    temp_draw.line([center_x - 16, eye_y - 5, center_x - 5, eye_y - 2], fill=(5, 5, 5, 230), width=3)
    temp_draw.line([center_x + 5, eye_y - 2, center_x + 16, eye_y - 5], fill=(5, 5, 5, 230), width=3)
    
    # 下眼睑线条 - 增加轮廓感
    temp_draw.line([center_x - 14, eye_y + 2, center_x - 8, eye_y + 3], fill=(10, 10, 10, 150), width=1)
    temp_draw.line([center_x + 8, eye_y + 3, center_x + 14, eye_y + 2], fill=(10, 10, 10, 150), width=1)
    
    # 身体躯干（更大）
    body_points = [
        (center_x - 24, center_y - 30),
        (center_x + 24, center_y - 30),
        (center_x + 32, center_y + 30),
        (center_x + 20, center_y + 50),
        (center_x, center_y + 43),
        (center_x - 20, center_y + 50),
        (center_x - 32, center_y + 30),
    ]
    temp_draw.polygon(body_points, fill=(35, 35, 35, 210))
    
    # 盘腿（更大，占满下方）
    # 左腿
    left_leg = [
        (center_x - 25, center_y + 23),
        (center_x - 50, center_y + 40),
        (center_x - 58, center_y + 60),
        (center_x - 40, center_y + 75),
        (center_x - 15, center_y + 67),
        (center_x - 8, center_y + 47),
    ]
    temp_draw.polygon(left_leg, fill=(40, 40, 40, 200))
    
    # 右腿
    right_leg = [
        (center_x + 25, center_y + 23),
        (center_x + 50, center_y + 40),
        (center_x + 58, center_y + 60),
        (center_x + 40, center_y + 75),
        (center_x + 15, center_y + 67),
        (center_x + 8, center_y + 47),
    ]
    temp_draw.polygon(right_leg, fill=(40, 40, 40, 200))
    
    # 手臂（结印姿势，往外画一点）
    # 左臂
    left_arm = [
        (center_x - 25, center_y - 15),
        (center_x - 45, center_y + 3),
        (center_x - 40, center_y + 23),
        (center_x - 15, center_y + 15),
    ]
    temp_draw.polygon(left_arm, fill=(35, 35, 35, 200))
    
    # 右臂
    right_arm = [
        (center_x + 25, center_y - 15),
        (center_x + 45, center_y + 3),
        (center_x + 40, center_y + 23),
        (center_x + 15, center_y + 15),
    ]
    temp_draw.polygon(right_arm, fill=(35, 35, 35, 200))
    
    # 双手结印
    temp_draw.ellipse([center_x - 13, center_y + 9, center_x + 13, center_y + 33], fill=(30, 30, 30, 220))
    
    # 3. 添加水墨晕染装饰（更靠近边缘）
    draw_ink_blot(temp_draw, center_x - 75, center_y - 20, 10, 80)
    draw_ink_blot(temp_draw, center_x + 75, center_y - 20, 10, 80)
    draw_ink_blot(temp_draw, center_x, center_y + 85, 12, 70)
    
    return temp_img, center_x, center_y

def create_cultivation_figure(size=(200, 200)):
    """创建水墨风格的修炼小人（带镂空气海）"""
    temp_img, center_x, center_y = create_cultivation_figure_base(size)
    
    # 5. 创建最终图像，把气海镂空
    final_img = Image.new('RGBA', size, (0, 0, 0, 0))
    
    # 先把小人画上去
    final_img.paste(temp_img, (0, 0), temp_img)
    
    # 创建一个掩码，把气海区域挖空
    final_draw = ImageDraw.Draw(final_img)
    dantian_radius = 26
    # 挖空气海区域（设置为完全透明）
    final_draw.ellipse(
        [center_x - dantian_radius, center_y + 10 - dantian_radius, 
         center_x + dantian_radius, center_y + 10 + dantian_radius],
        fill=(0, 0, 0, 0)
    )
    
    # 6. 添加整体模糊效果，增强水墨感
    final_img = final_img.filter(ImageFilter.GaussianBlur(radius=0.5))
    
    return final_img

def create_cultivation_figure_with_particles(size=(200, 200)):
    """创建水墨风格的修炼小人（带蓝色粒子光效，气海镂空）"""
    temp_img, center_x, center_y = create_cultivation_figure_base(size)
    
    # 5. 创建最终图像
    final_img = Image.new('RGBA', size, (0, 0, 0, 0))
    final_draw = ImageDraw.Draw(final_img)
    
    # 先画粒子光效（在小人下方）
    num_particles = 70
    particles_added = 0
    max_attempts = 500
    
    while particles_added < num_particles and max_attempts > 0:
        max_attempts -= 1
        
        # 粒子分布在小人周围（更大范围）
        angle = random.uniform(0, 2 * math.pi)
        distance = random.uniform(50, 95)
        x = center_x + int(distance * math.cos(angle))
        y = center_y + int(distance * math.sin(angle))
        
        # 检查粒子是否在脸部区域，如果是就跳过
        # 脸部区域：y在center_y - 90到center_y - 30之间，x在center_x - 40到center_x + 40之间
        face_top = center_y - 90
        face_bottom = center_y - 30
        face_left = center_x - 40
        face_right = center_x + 40
        
        if face_top <= y <= face_bottom and face_left <= x <= face_right:
            continue
        
        # 随机粒子大小
        particle_size = random.uniform(1.5, 4)
        
        # 随机透明度
        alpha = random.randint(40, 150)
        
        # 蓝色调粒子
        blue_variation = random.randint(-20, 20)
        color = (80 + blue_variation, 140 + blue_variation, 220 + blue_variation, alpha)
        
        final_draw.ellipse(
            [x - particle_size, y - particle_size, 
             x + particle_size, y + particle_size],
            fill=color
        )
        
        particles_added += 1
    
    # 再画小人
    final_img.paste(temp_img, (0, 0), temp_img)
    
    # 6. 挖空气海（和基础版本一样）
    dantian_radius = 26
    # 挖空气海区域（设置为完全透明）
    final_draw.ellipse(
        [center_x - dantian_radius, center_y + 10 - dantian_radius, 
         center_x + dantian_radius, center_y + 10 + dantian_radius],
        fill=(0, 0, 0, 0)
    )
    
    # 7. 添加整体模糊效果，增强水墨感
    final_img = final_img.filter(ImageFilter.GaussianBlur(radius=0.5))
    
    return final_img

def main():
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    output_dir = os.path.join(project_root, 'assets', 'cultivation')
    os.makedirs(output_dir, exist_ok=True)
    
    figure_size = (200, 200)
    
    # 生成基础版本（带镂空气海）
    figure = create_cultivation_figure(figure_size)
    figure.save(f'{output_dir}/cultivation_figure.png')
    print(f'生成修炼状态素材（带镂空气海）: cultivation_figure.png')
    
    # 生成带粒子光效的版本
    figure_particles = create_cultivation_figure_with_particles(figure_size)
    figure_particles.save(f'{output_dir}/cultivation_figure_particles.png')
    print(f'生成修炼状态素材（带蓝色粒子光效）: cultivation_figure_particles.png')

if __name__ == '__main__':
    main()

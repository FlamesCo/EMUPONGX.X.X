import pygame
import sys

# Initialize Pygame
pygame.init()

# Screen dimensions
screen_width = 800
screen_height = 600

# Colors
WHITE = (255, 255, 255)
RED = (255, 0, 0)
BLUE = (0, 0, 255)
BLACK = (0, 0, 0)

# Paddle properties
paddle_width = 100
paddle_height = 20
paddle_speed = 5

# Ball properties
ball_diameter = 20
ball_speed_x = 3
ball_speed_y = -3

# Brick properties
brick_width = 50
brick_height = 20
brick_rows = 5
brick_columns = 16

# Set up the screen
screen = pygame.display.set_mode((screen_width, screen_height))
pygame.display.set_caption("Breakout Game @Flames LABS 20XX")

# Paddle
paddle = pygame.Rect(screen_width // 2 - paddle_width // 2, screen_height - 40, paddle_width, paddle_height)

# Ball
ball = pygame.Rect(screen_width // 2 - ball_diameter // 2, screen_height // 2 - ball_diameter // 2, ball_diameter, ball_diameter)

# Bricks
bricks = []
for row in range(brick_rows):
    for col in range(brick_columns):
        brick = pygame.Rect(col * (brick_width + 5) + 35, row * (brick_height + 5) + 35, brick_width, brick_height)
        bricks.append(brick)

# Main game loop
def main_game():
    running = True
    global ball_speed_x, ball_speed_y

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

        # Paddle movement
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT] and paddle.left > 0:
            paddle.move_ip(-paddle_speed, 0)
        if keys[pygame.K_RIGHT] and paddle.right < screen_width:
            paddle.move_ip(paddle_speed, 0)

        # Ball movement
        ball.move_ip(ball_speed_x, ball_speed_y)

        # Ball collision with walls
        if ball.left <= 0 or ball.right >= screen_width:
            ball_speed_x = -ball_speed_x
        if ball.top <= 0:
            ball_speed_y = -ball_speed_y
        if ball.bottom >= screen_height:
            running = False  # Game over

        # Ball collision with paddle
        if ball.colliderect(paddle):
            ball_speed_y = -ball_speed_y

        # Ball collision with bricks
        for brick in bricks[:]:
            if ball.colliderect(brick):
                ball_speed_y = -ball_speed_y
                bricks.remove(brick)
                break

        # Drawing
        screen.fill(BLACK)
        pygame.draw.rect(screen, WHITE, paddle)
        pygame.draw.ellipse(screen, RED, ball)
        for brick in bricks:
            pygame.draw.rect(screen, BLUE, brick)

        pygame.display.flip()
        pygame.time.delay(30)

    pygame.quit()
    sys.exit()

# Main menu
def main_menu():
    menu_font = pygame.font.Font(None, 36)
    start_text = menu_font.render("Press 'Z' to start", True, WHITE)
    start_rect = start_text.get_rect(center=(screen_width // 2, screen_height // 2))

    while True:
        screen.fill(BLACK)
        screen.blit(start_text, start_rect)

        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_z:
                    main_game()

        pygame.display.flip()

main_menu()

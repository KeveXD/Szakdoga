import pygame
import random

pygame.init()

width, height = 800, 600

black = (0, 0, 0)
white = (255, 255, 255)
green = (0, 255, 0)

speed = 10

x, y = width // 2, height // 2
snake = [(x, y)]
snake_length = 1

food_x, food_y = random.randint(0, width - 20), random.randint(0, height - 20)

screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Snake Game")

direction = "RIGHT"
change_to = direction

score = 0

game_over = False

while not game_over:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            game_over = True

        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_UP and direction != "DOWN":
                change_to = "UP"
            if event.key == pygame.K_DOWN and direction != "UP":
                change_to = "DOWN"
            if event.key == pygame.K_LEFT and direction != "RIGHT":
                change_to = "LEFT"
            if event.key == pygame.K_RIGHT and direction != "LEFT":
                change_to = "RIGHT"

    if change_to == "UP" and direction != "DOWN":
        direction = "UP"
    if change_to == "DOWN" and direction != "UP":
        direction = "DOWN"
    if change_to == "LEFT" and direction != "RIGHT":
        direction = "LEFT"
    if change_to == "RIGHT" and direction != "LEFT":
        direction = "RIGHT"

    if direction == "UP":
        y -= 20
    if direction == "DOWN":
        y += 20
    if direction == "LEFT":
        x -= 20
    if direction == "RIGHT":
        x += 20

    snake.append((x, y))

    if len(snake) > snake_length:
        del snake[0]

    if x == food_x and y == food_y:
        food_x, food_y = random.randint(0, width - 20), random.randint(0, height - 20)
        snake_length += 1
        score += 1

    for segment in snake[:-1]:
        if segment == (x, y):
            game_over = True

    screen.fill(black)
    for segment in snake:
        pygame.draw.rect(screen, green, (segment[0], segment[1], 20, 20))

    pygame.draw.rect(screen, white, (food_x, food_y, 20, 20))

    font = pygame.font.Font(None, 36)
    text = font.render(f"Pontszám: {score}", True, white)
    screen.blit(text, (10, 10))

    if x < 0 or x >= width or y < 0 or y >= height:
        game_over = True

    pygame.display.update()

    pygame.time.Clock().tick(speed)

font = pygame.font.Font(None, 72)
text = font.render("Játék vége!", True, white)
text_rect = text.get_rect()
text_rect.center = (width // 2, height // 2)
screen.blit(text, text_rect)
pygame.display.update()

pygame.time.delay(2000)
pygame.quit()

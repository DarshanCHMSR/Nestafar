# Restaurant Photos Guide

## Overview
This guide provides requirements and recommendations for restaurant photos in the Nestafar food ordering app, inspired by modern food delivery platforms like Instamart.

## Photo Requirements

### Technical Specifications
- **Resolution**: Minimum 1200x800 pixels, recommended 1920x1280 pixels
- **Aspect Ratio**: 3:2 or 16:9 (landscape orientation preferred)
- **Format**: JPEG or PNG
- **File Size**: 200KB - 2MB per image
- **Quality**: High resolution, sharp focus, good lighting

### Visual Requirements

#### 1. Main Restaurant Hero Images
**Current files needed:**
- `restaurant1.jpg` - Italian/Pizza restaurant
- `restaurant2.jpg` - Fast food/Burger restaurant  
- `restaurant3.jpg` - Asian/Chinese restaurant
- `restaurant4.jpg` - Healthy/Salad restaurant

**Style Guidelines:**
- **Bright, inviting storefront or interior shots**
- **Clean, modern restaurant ambiance**
- **Good natural lighting (avoid harsh shadows)**
- **Professional food styling visible**
- **Warm, welcoming atmosphere**

#### 2. Photo Style Examples

##### ✅ Good Examples:
- Modern restaurant interior with warm lighting
- Fresh food displays prominently featured
- Clean, organized kitchen/counter areas
- Happy staff or customers (optional)
- Signature dishes artfully presented
- Brand colors and themes visible

##### ❌ Avoid:
- Dark, poorly lit images
- Cluttered or messy backgrounds
- Blurry or low-quality photos
- Overly staged or artificial looking
- Heavy filters or oversaturation
- Empty or uninviting spaces

### Photo Categories by Restaurant Type

#### 1. Italian Restaurant (restaurant1.jpg)
- **Preferred**: Wood-fired pizza oven, pasta station, or elegant dining area
- **Color Palette**: Warm browns, reds, yellows
- **Elements**: Traditional Italian décor, fresh ingredients, artisanal prep

#### 2. Fast Food Restaurant (restaurant2.jpg)
- **Preferred**: Modern counter service area, fresh ingredients display
- **Color Palette**: Bright, energetic colors (reds, yellows, oranges)
- **Elements**: Quick service setup, visible food prep, contemporary design

#### 3. Asian Restaurant (restaurant3.jpg)
- **Preferred**: Wok station, fresh ingredient display, or modern Asian dining
- **Color Palette**: Clean whites, natural wood tones, red accents
- **Elements**: Traditional elements mixed with modern design

#### 4. Healthy Restaurant (restaurant4.jpg)
- **Preferred**: Fresh salad bar, juice station, or clean modern interior
- **Color Palette**: Fresh greens, whites, natural tones
- **Elements**: Organic ingredients, clean prep areas, health-focused messaging

## Photo Sources and Recommendations

### Option 1: Free Stock Photos
**Recommended Sources:**
- Unsplash.com (restaurant, food service, commercial kitchen)
- Pexels.com (restaurant interior, food business)
- Freepik.com (restaurant photos - check licensing)

**Search Terms:**
- "modern restaurant interior"
- "restaurant kitchen"
- "food service counter"
- "pizza restaurant interior"
- "fast food restaurant"
- "asian restaurant modern"
- "healthy restaurant salad bar"

### Option 2: AI Generated Images
**Tools:**
- DALL-E, Midjourney, or Stable Diffusion
- **Prompts**: "modern [cuisine type] restaurant interior, bright lighting, professional photography, welcoming atmosphere"

### Option 3: Professional Photography
- Local restaurant photography
- Commercial stock photography services
- Custom shoots for authentic local feel

## Implementation Steps

### 1. Download/Create Photos
1. Obtain 4 high-quality restaurant photos matching the specifications above
2. Rename them as: `restaurant1.jpg`, `restaurant2.jpg`, `restaurant3.jpg`, `restaurant4.jpg`
3. Resize to recommended dimensions if needed

### 2. Add to Project
```bash
# Place files in:
assets/images/restaurant1.jpg
assets/images/restaurant2.jpg  
assets/images/restaurant3.jpg
assets/images/restaurant4.jpg
```

### 3. Update pubspec.yaml (if needed)
Ensure assets are declared:
```yaml
flutter:
  assets:
    - assets/images/
```

## Modern Design Enhancements

### Additional Recommendations
1. **Consistent Style**: All photos should have similar lighting and quality
2. **Brand Coherence**: Photos should align with the app's modern, clean aesthetic
3. **Loading States**: Ensure photos load quickly and have loading placeholders
4. **Responsive Design**: Photos should look good on all screen sizes
5. **Accessibility**: Include alt text descriptions for photos

### Future Enhancements
- Multiple photos per restaurant (gallery view)
- Seasonal photo updates
- User-generated content integration
- Dynamic photo optimization based on connection speed

## Testing Checklist
- [ ] All 4 restaurant photos load correctly
- [ ] Photos maintain quality on different screen sizes
- [ ] Loading states work properly
- [ ] Photos align with restaurant themes and cuisines
- [ ] Overall visual coherence with app design
- [ ] Performance impact is minimal

## Contact
For questions about photo requirements or implementation, refer to the development team or UI/UX guidelines.
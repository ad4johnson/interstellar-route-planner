import matplotlib.pyplot as plt

steps = ['Load Dataset', 'Impute', 'Encode', 'Scale', 'Split']

fig, ax = plt.subplots(figsize=(5, 7))  # slightly taller
box_props = dict(boxstyle="round,pad=0.5", facecolor='lightblue', edgecolor='gray')

for i, step in enumerate(steps):
    y = len(steps) - i
    ax.text(0.5, y, step, fontsize=12, ha='center', va='center', bbox=box_props)
    if i < len(steps) - 1:
        ax.annotate('', xy=(0.5, y - 0.6), xytext=(0.5, y - 0.2),
                    arrowprops=dict(arrowstyle='->', color='gray', lw=2))

ax.set_xlim(0, 1)
ax.set_ylim(0, len(steps) + 1)
ax.axis('off')

plt.subplots_adjust(top=0.9, bottom=0.1)  # gives room for title and layout
plt.title("Figure 7: Data Preprocessing Pipeline", fontsize=14, pad=10)
plt.show()
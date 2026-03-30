"""Add subscription status to user

Revision ID: a1b2c3d4e5f6
Revises: 83e8c88f94f7
Create Date: 2026-03-30 12:30:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = 'a1b2c3d4e5f6'
down_revision: Union[str, Sequence[str], None] = '83e8c88f94f7'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema: add is_subscribed column to users table."""
    op.add_column('users', sa.Column('is_subscribed', sa.Boolean(), nullable=False, server_default='true'))
    op.create_index(op.f('ix_users_is_subscribed'), 'users', ['is_subscribed'])


def downgrade() -> None:
    """Downgrade schema: remove is_subscribed column from users table."""
    op.drop_index(op.f('ix_users_is_subscribed'), table_name='users')
    op.drop_column('users', 'is_subscribed')
